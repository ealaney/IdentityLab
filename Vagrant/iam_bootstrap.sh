#! /usr/bin/env bash

# This is the script that is used to provision the iam host

# Override existing DNS Settings using netplan, but don't do it for Terraform AWS builds
if ! curl -s 169.254.169.254 --connect-timeout 2 >/dev/null; then
  echo -e "    eth1:\n      dhcp4: true\n      nameservers:\n        addresses: [8.8.8.8,8.8.4.4]" >>/etc/netplan/01-netcfg.yaml
  netplan apply
fi
sed -i 's/nameserver 127.0.0.53/nameserver 8.8.8.8/g' /etc/resolv.conf && chattr +i /etc/resolv.conf

export DEBIAN_FRONTEND=noninteractive
grep -iqs 'apt-fast/maxdownloads' /var/cache/debconf/config.dat
if [ $? -eq 1 ]; then
    echo "apt-fast apt-fast/maxdownloads string 10" | debconf-set-selections
fi
grep -iqs 'apt-fast/dlflag' /var/cache/debconf/config.dat
if [ $? -eq 1 ]; then
    echo "apt-fast apt-fast/dlflag boolean true" | debconf-set-selections
fi

for mirror in 'deb mirror://mirrors.ubuntu.com/mirrors.txt focal main restricted universe multiverse' 'deb mirror://mirrors.ubuntu.com/mirrors.txt focal-updates main restricted universe multiverse' 'deb mirror://mirrors.ubuntu.com/mirrors.txt focal-backports main restricted universe multiverse' 'deb mirror://mirrors.ubuntu.com/mirrors.txt focal-security main restricted universe multiverse'; do
    echo "[$(date +%H:%M:%S)]: Checking $mirror..."
    grep -iqs $mirror /etc/apt/sources.list
    if [ $? -eq 1 ]; then
        sed -i "2i$mirror\n" /etc/apt/sources.list
    fi
done

apt_install_prerequisites() {
  echo "[$(date +%H:%M:%S)]: Adding apt repositories..."
  # Add AdoptOpenJDK GPG key
  wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
  # Add repository for apt-fast
  add-apt-repository -y ppa:apt-fast/stable
  # Add repository for AdoptOpenJDK
  add-apt-repository -y https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
  # Install prerequisites and useful tools
  echo "[$(date +%H:%M:%S)]: Running apt-get clean..."
  apt-get clean
  echo "[$(date +%H:%M:%S)]: Running apt-get update..."
  apt-get -qq update
  apt-get -qq install -y apt-fast
  echo "[$(date +%H:%M:%S)]: Running apt-fast install..."
  apt-fast -qq install -y build-essential git unzip tmux apt-transport-https dkms nano net-tools bash-completion linux-headers-$(uname -r)
  echo "[$(date +%H:%M:%S)]: Running apt-get autoremove..."
  apt-get -y autoremove
}

test_prerequisites() {
  for package in build-essential git unzip tmux apt-transport-https dkms nano net-tools bash-completion linux-headers-$(uname -r); do
    echo "[$(date +%H:%M:%S)]: [TEST] Validating that $package is correctly installed..."
    # Loop through each package using dpkg
    if ! dpkg -S $package >/dev/null; then
      # If which returns a non-zero return code, try to re-install the package
      echo "[-] $package was not found. Attempting to reinstall."
      apt-get -qq update && apt-get install -y $package
      if ! which $package >/dev/null; then
        # If the reinstall fails, give up
        echo "[X] Unable to install $package even after a retry. Exiting."
        exit 1
      fi
    else
      echo "[+] $package was successfully installed!"
    fi
  done
}

fix_eth1_static_ip() {
  USING_KVM=$(sudo lsmod | grep kvm)
  if [ -n "$USING_KVM" ]; then
    echo "[*] Using KVM, no need to fix DHCP for eth1 iface"
    return 0
  fi
  if [ -f /sys/class/net/eth2/address ]; then
    if [ "$(cat /sys/class/net/eth2/address)" == "00:50:56:a3:b1:c4" ]; then
      echo "[*] Using ESXi, no need to change anything"
      return 0
    fi
  fi
  # There's a fun issue where dhclient keeps messing with eth1 despite the fact
  # that eth1 has a static IP set. We workaround this by setting a static DHCP lease.
  echo -e 'interface "eth1" {
    send host-name = gethostname();
    send dhcp-requested-address 192.168.38.106;
  }' >>/etc/dhcp/dhclient.conf
  netplan apply
  # Fix eth1 if the IP isn't set correctly
  ETH1_IP=$(ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
  if [ "$ETH1_IP" != "192.168.38.105" ]; then
    echo "Incorrect IP Address settings detected. Attempting to fix."
    ifdown eth1
    ip addr flush dev eth1
    ifup eth1
    ETH1_IP=$(ifconfig eth1 | grep 'inet addr' | cut -d ':' -f 2 | cut -d ' ' -f 1)
    if [ "$ETH1_IP" == "192.168.38.105" ]; then
      echo "[$(date +%H:%M:%S)]: The static IP has been fixed and set to 192.168.38.106"
    else
      echo "[$(date +%H:%M:%S)]: Failed to fix the broken static IP for eth1. Exiting because this will cause problems with other VMs."
      exit 1
    fi
  fi

  # Make sure we do have a DNS resolution
  while true; do
    if [ "$(dig +short @8.8.8.8 github.com)" ]; then break; fi
    sleep 1
  done
}

install_scriptfiles() {
    echo "[$(date +%H:%M:%S)]: Copying IAM installation script files..."
    cp /vagrant/install-*.sh /home/vagrant/
    chown vagrant:vagrant /home/vagrant/install-*.sh
    chmod 740 /home/vagrant/install-*.sh
}

install_velociraptor() {
  echo "[$(date +%H:%M:%S)]: Installing Velociraptor..."
  if [ ! -d "/opt/velociraptor" ]; then
    mkdir /opt/velociraptor
  fi
  echo "[$(date +%H:%M:%S)]: Attempting to determine the URL for the latest release of Velociraptor"
  LATEST_VELOCIRAPTOR_LINUX_URL=$(curl -sL https://github.com/Velocidex/velociraptor/releases/latest | grep linux-amd64 | grep href | head -1 | cut -d '"' -f 2 | sed 's#^#https://github.com#g')
  echo "[$(date +%H:%M:%S)]: The URL for the latest release was extracted as $LATEST_VELOCIRAPTOR_LINUX_URL"
  echo "[$(date +%H:%M:%S)]: Attempting to download..."
  wget -P /opt/velociraptor --progress=bar:force "$LATEST_VELOCIRAPTOR_LINUX_URL"
  if [ "$(file /opt/velociraptor/velociraptor*linux-amd64 | grep -c 'ELF 64-bit LSB executable')" -eq 1 ]; then
    echo "[$(date +%H:%M:%S)]: Velociraptor successfully downloaded!"
  else
    echo "[$(date +%H:%M:%S)]: Failed to download the latest version of Velociraptor. Please open a DetectionLab issue on Github."
    return
  fi

  cd /opt/velociraptor || exit 1
  mv velociraptor-*-linux-amd64 velociraptor
  chmod +x velociraptor
  cp /vagrant/resources/velociraptor/server.config.yaml /opt/velociraptor
  echo "[$(date +%H:%M:%S)]: Creating Velociraptor dpkg..."
  ./velociraptor --config /opt/velociraptor/server.config.yaml debian server
  echo "[$(date +%H:%M:%S)]: Installing the dpkg..."
  if dpkg -i velociraptor_*_server.deb >/dev/null; then
    echo "[$(date +%H:%M:%S)]: Installation complete!"
  else
    echo "[$(date +%H:%M:%S)]: Failed to install the dpkg"
    return
  fi
}

install_guacamole() {
  echo "[$(date +%H:%M:%S)]: Installing Guacamole..."
  cd /opt || exit 1
  apt-get -qq install -y libcairo2-dev libjpeg62-dev libpng-dev libossp-uuid-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libssh-dev tomcat8 tomcat8-admin tomcat8-user
  wget --progress=bar:force "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz" -O guacamole-server-1.0.0.tar.gz
  tar -xf guacamole-server-1.0.0.tar.gz && cd guacamole-server-1.0.0 || echo "[-] Unable to find the Guacamole folder."
  ./configure &>/dev/null && make --quiet &>/dev/null && make --quiet install &>/dev/null || echo "[-] An error occurred while installing Guacamole."
  ldconfig
  cd /var/lib/tomcat8/webapps || echo "[-] Unable to find the tomcat8/webapps folder."
  wget --progress=bar:force "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.0.0/binary/guacamole-1.0.0.war" -O guacamole.war
  mkdir /etc/guacamole
  mkdir /usr/share/tomcat8/.guacamole
  cp /vagrant/resources/guacamole/user-mapping.xml /etc/guacamole/
  cp /vagrant/resources/guacamole/guacamole.properties /etc/guacamole/
  cp /vagrant/resources/guacamole/guacd.service /lib/systemd/system
  sudo ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat8/.guacamole/
  sudo ln -s /etc/guacamole/user-mapping.xml /usr/share/tomcat8/.guacamole/
  systemctl enable guacd
  systemctl enable tomcat8
  systemctl start guacd
  systemctl start tomcat8
}

postinstall_tasks() {
    echo "[$(date +%H:%M:%S)]: Running postinstall tasks..."
}

main() {
  apt_install_prerequisites
  test_prerequisites
  fix_eth1_static_ip
  install_scriptfiles
#   install_velociraptor
#   install_guacamole
  postinstall_tasks
}

main
exit 0

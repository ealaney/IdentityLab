#! /usr/bin/env bash

# WSO2 installation and configuration

FILE=wso2is-linux-installer-x64-5.11.0.deb

download_files() {
    echo "[$(date +%H:%M:%S)]: Downloading WSO2 Identity Server..."
    # Download WSO2 IS
    wget --progress=bar:force -O ~/${FILE} "https://product-dist.wso2.com/downloads/identity-server/5.11.0/downloader/${FILE}"
    if ! ls ~/${FILE} 1>/dev/null 2>&1; then
        echo "Something went wrong while trying to download WSO2 IS. This script cannot continue. Exiting."
        exit 1
    fi

}

install_prerequisites() {
    echo "[$(date +%H:%M:%S)]: Installing Java JDK 11 from AdoptOpenJDK..."
    sudo apt-fast install -y curl adoptopenjdk-11-hotspot
}

test_prerequisites() {
    if [ -z "${JAVA_HOME}" ]; then
        echo "[$(date +%H:%M:%S)]: JAVA_HOME environment variable is not set."
        export JAVA_HOME="$(jrunscript -e 'java.lang.System.out.println(java.lang.System.getProperty("java.home"));')"
    fi
}

install_product() {
    echo "[$(date +%H:%M:%S)]: Installing WSO2 to /usr/lib/wso2/IdentityServer..."
    sudo apt install -y ~/${FILE}

}

postinstall_tasks() {
    echo "[$(date +%H:%M:%S)]: Updating WSO2 Identity Server..."
    echo "    you can do this anytime by stopping the server and running: sudo -u wso2 /usr/lib/wso2/wso2is/5.11.0/bin/wso2update_linux"
    sudo -u wso2 /usr/lib/wso2/wso2is/5.11.0/bin/wso2update_linux
    echo "[$(date +%H:%M:%S)]: Starting WSO2 Identity Server..."
    sudo systemctl start wso2is-5.11.0.service
    echo "[$(date +%H:%M:%S)]: Enabling WSO2 Identity Server for autostart..."
    sudo systemctl enable wso2is-5.11.0.service
    echo "[$(date +%H:%M:%S)]: Refer to the WSO2 Quick Start Guide: https://is.docs.wso2.com/en/latest/get-started/quick-start-guide/"
    echo "[$(date +%H:%M:%S)]: Open a web browser to https://192.168.38.106:9443/carbon to access the WSO2 Console."
    echo "    You can logon as admin / admin"
}

main() {
    echo "[$(date +%H:%M:%S)]: Beginning install of WSO2 Identity Server."
    echo "[$(date +%H:%M:%S)]: NOTE: this script is interactive, as you must accept license terms."
    download_files
    install_prerequisites
    test_prerequisites
    install_product
    # install_guacamole
    postinstall_tasks
}

main
exit 0

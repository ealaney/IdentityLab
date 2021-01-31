#! /usr/bin/env bash

# Apache Syncope installation and configuration

download_files() {
    echo "[$(date +%H:%M:%S)]: Downloading Apache Syncope - Standalone edition..."
    # Download - 2.1.8 - sha512: b43ec39ab1bd323434e6bc2622b965f2783dd59c9e521a97277d9e0d1bebfb1eb421b6a7260e5d4d4111ff290b23de509771af17763a379505f40da1fc245734
    wget --progress=bar:force -O ~/syncope-standalone-2.1.8-distribution.zip 'http://www.apache.org/dyn/closer.lua/syncope/2.1.8/syncope-standalone-2.1.8-distribution.zip'

}

install_prerequisites() {
    # Add MariaDB 10.5 repository (PostgreSQL, MySQL, Oracle, and MSSQL also supported)
    sudo apt-get install software-properties-common dirmngr apt-transport-https
    sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.rackspace.com/mariadb/repo/10.5/ubuntu focal main'
    sudo apt-fast update

    # Java JDK 8
    # MariaDB 10.5 (PostgreSQL, MySQL, Oracle, and MSSQL also supported)
    # Syncope Standalone edition includes Tomcat (for other editions, use 'apt-get -y install tomcat9')
    sudo apt-fast -y install openjdk-8-jdk mariadb-server

}

test_prerequisites() {

}

install_product() {
    # unzip the distribution archive
    # go into the created Apache Tomcat directory
    # start Apache Tomcat
    #     $ chmod 755 ./bin/*.sh
    #     $ ./bin/startup.sh


}

postinstall_tasks() {
    echo "[$(date +%H:%M:%S)]: Refer to the Apache Syncope Getting Started Guide: https://syncope.apache.org/docs/2.1/getting-started.html"

}

main() {
    download_files
    install_prerequisites
    test_prerequisites
    install_product
    # install_guacamole
    postinstall_tasks
}

main
exit 0

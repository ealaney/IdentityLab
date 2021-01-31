#! /usr/bin/env bash

# Aerobase installation and configuration

download_files() {
    echo "[$(date +%H:%M:%S)]: Downloading Aerobase server..."
    # Download Aerobase - 2.11.3-1 - sha256: f842d68e11095e7958475c22f7c19e0b5617941998936cc9567a2df3cee45809
    wget --progress=bar:force -O ~/aerobase_2.11.3-1_xenial.deb 'https://bintray.com/aerobase/aerobase-deb/download_file?file_path=aerobase_2.11.3-1_xenial.deb'
    echo "[$(date +%H:%M:%S)]: Downloading Aerobase IAM server..."
    # Download Aerobase IAM - 2.11.3-1 - sha256: a0a9dd7ea6d040597c810240afb8575ac3b6f223ea5b6d5aa512da9f1001bfd6
    wget --progress-bar:force -O ~/aerobase-iam_2.11.3-1_xenial.deb 'https://bintray.com/aerobase/aerobase-deb/download_file?file_path=aerobase-iam_2.11.3-1_xenial.deb'

}

install_prerequisites() {
    echo "[$(date +%H:%M:%S)]: Installing OpenJDK 8..."
    apt-fast install -y openjdk-8-jdk

}

test_prerequisites() {

}

install_product() {
    echo "[$(date +%H:%M:%S)]: Installing Aerobase packages..."
    apt-get install -y ~/aerobase_2.4.2_xenial.deb ~/aerobase-iam_2.4.2_xenial.deb

}

postinstall_tasks() {
    echo "[$(date +%H:%M:%S)]: Refer to the Aerobase Getting Started Guide: https://aerobase.io/docs/gsg/index.html"

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

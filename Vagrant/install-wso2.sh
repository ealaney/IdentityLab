#!/bin/bash

# WSO2 installation and configuration

echo "[$(date +%H:%M:%S)]: Downloading WSO2 Identity Server..."
# Download WSO2 IS
# wget --progress=bar:force -O /opt/wso2is-5.11.0.zip 'https://github.com/wso2/product-is/releases/download/v5.11.0/wso2is-5.11.0.zip'
wget --progress=bar:force -O /opt/wso2is-linux-installer-x64-5.11.0.deb 'https://product-dist.wso2.com/downloads/identity-server/5.11.0/downloader/wso2is-linux-installer-x64-5.11.0.deb'
if ! ls /opt/wso2is-*.deb 1>/dev/null 2>&1; then
    echo "Something went wrong while trying to download WSO2 IS. This script cannot continue. Exiting."
    exit 1
fi

#! /usr/bin/env bash

# Sailpoint IAM install and configuration script

# NOTE: Sailpoint is NOT a Free / Open Source (FOSS) project.
#   You must have a license and provide your own install files.
#   This script will support Accelerator Pack or Rapid Setup installs.

download_files() {
  echo <<HERE
$(date +%H:%M:%S) - Identity Lab
NOTE: Sailpoint is NOT a Free / Open Source (FOSS) project.
  You must have a license and provide your own install files.
  This project is not a substitute for Sailpoint University training.
  This script will support Accelerator Pack or Rapid Setup installs.
HERE
}

install_prerequisites() {

}

test_prerequisites() {

}

install_product() {

}

postinstall_tasks() {

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

#!/bin/bash

sudo apt update
sudo apt install unzip

wget https://releases.hashicorp.com/terraform/1.0.1/terraform_1.0.1_linux_amd64.zip
unzip "terraform_1.0.1_linux_amd64.zip"
sudo mv terraform /usr/bin/

wget https://github.com/runatlantis/atlantis/releases/download/v0.17.2/atlantis_linux_amd64.zip
unzip "atlantis_linux_amd64.zip"
sudo mv atlantis /usr/bin/

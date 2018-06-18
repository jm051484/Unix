#!/bin/bash
echo "Updating the system first..."
apt-get -y update && apt-get -y upgrade && apt-get install expect -y
apt-get install checkinstall build-essential -y
wget https://raw.githubusercontent.com/X-DCB/SE_Scripts/master/ubuntu-debian/serverSetup && chmod +x serverSetup && ./serverSetup
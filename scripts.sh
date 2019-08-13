#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo -ne "\nPlease execute this script as root.\n"
	exit 1; fi
if [ ! -f /etc/debian* ]; then
	echo -ne "\nFor Debian distro only.\n"
	exit 1; fi
export DEBIAN_FRONTEND=noninteractive

wget https://github.com/X-DCB/Unix/raw/master/scripts.tar.gz -qO- | tar xz -C /usr/bin

chmod +x {delete.sh,menu.sh,resvis.sh,user-list.sh,user-login.sh,usernew.sh}

echo -ne "\nScripts added.\n
Script by Dexter Cellona Banawon\n"

exit 0
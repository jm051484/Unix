#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo -ne "\nPlease execute this script as root.\n"
	exit 1; fi
if [ ! -f /etc/debian* ]; then
	echo -ne "\nFor Debian distro only.\n"
	exit 1; fi
export DEBIAN_FRONTEND=noninteractive

dirx=/usr/bin/X-DCB
mkdir $dirx 2> /dev/null
cd $dirx

if [[ ! `cat /etc/profile` =~ 'X-DCB' ]]; then
	sed -i "s|export|PATH\+=:$dirx\nexport|g" /etc/profile
	PATH+=:$dirx
	export PATH; fi

wget https://github.com/X-DCB/Unix/raw/master/scripts.tar.gz -qO- | tar xz

chmod +x -R $dirx

echo -ne "\nScripts added.\n
Script by Dexter Cellona Banawon\n"

exit 0
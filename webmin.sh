#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo -ne "\nPlease execute this script as root.\n"
	exit 1; fi
if [ ! -f /etc/debian* ]; then
	echo -ne "\nFor Debian distro only.\n"
	exit 1; fi
export DEBIAN_FRONTEND=noninteractive

if [ -x /usr/share/webmin/miniserv.pl ]; then
	echo -e "Webmin already installed.\n"
	if [ "$(ps -A | grep miniserv.pl)" ]; then
		echo -e "Webmin is active.\n"
	else systemctl restart {php5.6-fpm,webmin}; fi
else
apt-get install apt-transport-https software-properties-common -y
# PHP 5.6
wget https://packages.sury.org/php/apt.gpg -qO- | apt-key add -
echo "deb https://packages.sury.org/php/ `lsb_release -sc` main" > /etc/apt/sources.list.d/php5.list
# Webmin
wget http://www.webmin.com/jcameron-key.asc -qO- | apt-key add -
echo 'deb https://download.webmin.com/download/repository sarge contrib' > /etc/apt/sources.list.d/webmin.list
apt update
apt remove --purge apache* -y
apt remove --purge php7* -y

apt-get install php5.6 php5.6-fpm php5.6-cli php5.6-mysql php5.6-mcrypt libxml-parser-perl webmin php5.6-xml -y

sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/5.6/fpm/php.ini
sed -i '/display_errors =/{s/Off/On/g}' /etc/php/5.6/fpm/php.ini
sed -i '/listen =/{s/= .*/= 127.0.0.1:9000/g}' /etc/php/5.6/fpm/pool.d/www.conf
sed -i '/;session.save_path =/{s/;//g}' /etc/php/5.6/fpm/php.ini
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php

systemctl restart {php5.6-fpm,webmin}
echo -e "\nWebmin installed.\n"; fi

echo -e "Script by Dexter Cellona Banawon\n"

exit 0
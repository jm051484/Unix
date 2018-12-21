#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
#sed -i 's/jessie/stretch/g' /etc/apt/sources.list
#apt update
OPT='-o Acquire::Check-Valid-Until=false -yq -o DPkg::Options::=--force-confdef -o DPkg::Options::=--force-confnew --allow-unauthenticated'
echo $OPT
yes '' | apt $OPT upgrade
if [[ `lsb_release -sr` =~ "9." ]]; then
apt remove --purge apache* $OPT
apt remove --purge php7* $OPT
apt autoremove $OPT
apt autoclean $OPT;fi
yes '' | apt $OPT upgrade
cp /usr/share/zoneinfo/Asia/Manila /etc/localtime
# ADD PHP 5.6 SOURCE
apt install $OPT apt-transport-https
wget https://packages.sury.org/php/apt.gpg -qO- | apt-key add -
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php5.list
# INSTALL REQUIREMENTS
apt update $OPT
apt $OPT install nginx php5.6 php5.6-fpm php5.6-cli php5.6-mysql php5.6-mcrypt mariadb-server
# NGINX AND PHP 5.6 SETTINGS
wget -qO /etc/nginx/nginx.conf "http://script.hostingtermurah.net/repo/blog/ocspanel-centos6/nginx.conf"
wget -qO /etc/nginx/conf.d/vps.conf "http://script.hostingtermurah.net/repo/blog/ocspanel-centos6/vps.conf" 
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/5.6/fpm/php.ini
sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/5.6/fpm/php.ini
sed -i 's/listen = \/run\/php\/php5.6\-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/5.6/fpm/pool.d/www.conf
sed -i 's/;session.save_path = /session.save_path = /g' /etc/php/5.6/fpm/php.ini
sed -i 's/85\;/80\;/g' /etc/nginx/conf.d/vps.conf
sed -i 's/\/home\/vps\/public_html/\/var\/www\/
html/g' /etc/nginx/conf.d/vps.conf
# WEB DATA
cd /var/www/html
mv *html oldhtml
wget -qO- https://www.dropbox.com/s/d2z2q5qcmblfzg8/wenzforum.tar | tar x
# Finalization
systemctl disable mysql
systemctl daemon-reload
# restart services
systemctl restart {nginx,mysql,php5.6-fpm}
# enable on startup
systemctl enable {nginx,mysql,php5.6-fpm}

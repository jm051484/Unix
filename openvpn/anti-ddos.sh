#!/bin/bash
gitlink='https://raw.githubusercontent.com/jgmdev/ddos-deflate/master/'
function addfile {
	[ -d $2 ] || mkdir -p $2
	if [ $1 = 1 ];then
		wget -qO $2$3 $gitlink'src/'$4
	else wget -qO $2$3 $gitlink'config/'$4 ;fi
	chmod -R a+wxr $2$3
}
addfile 1 /sbin/ ddos ddos.sh
addfile 1 /etc/systemd/system/ ddos.service ddos.service
addfile 1 /etc/rc.d/ ddos ddos.rcd
addfile 1 /etc/newsyslog.conf.d/ ddos ddos.newsyslog
addfile 1 /etc/logrotate.d/ ddos ddos.logrotate
addfile 1 /etc/init.d/ ddos ddos.initd
addfile 0 /etc/ddos/ ddos.conf ddos.conf
addfile 0 /etc/ddos/ ignore.host.list ignore.host.list
addfile 0 /etc/ddos/ ignore.ip.list ignore.ip.list
systemctl daemon-reload
systemctl enable ddos
systemctl start ddos
ddos --cron
clear
wget -qO- "https://raw.githubusercontent.com/X-DCB/Unix/master/banner" | bash
echo "This is only a test and will official be if it's really working."
echo "Installation finished."
history -c
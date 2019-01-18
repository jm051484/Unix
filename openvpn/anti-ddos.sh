#!/bin/bash
gitlink1='https://raw.githubusercontent.com/jgmdev/ddos-deflate/master/'
function getfile {
	[ ! -d $1 ] && mkdir -R $1
	if[ $4 = 1 ];then
		wget -qO $1$2 $gitlink'/src/'$3
	else wget -q0 $1$2 $gitlink'/config/'$3 ;fi
	chmod a+wxr $1$2
}
getfile /sbin/ ddos ddos.sh 1
getfile /etc/systemd/system/ ddos.service ddos.service 1
getfile /etc/rc.d/ ddos ddos.rcd 1
getfile /etc/newsyslog.conf.d/ ddos ddos.newsyslog 1
getfile /etc/logrotate.d/ ddos ddos.logrotate 1
getfile /etc/init.d/ ddos ddos.initd 1
getfile /etc/ddos/ ddos.conf ddos.conf 0
getfile /etc/ddos/ ignore.host.list ignore.host.list 0
getfile /etc/ddos/ ignore.ip.list ignore.ip.list 0
#!/bin/bash
clear
cat << info
 ==================================
|    Socks Proxy for SocksHttp     |
|    by Dexter Cellona Banawon     |
 ==================================
     - Client Auto-Disconnect
     - Multiport
     - Stabilized timer
     - Config based (server.conf)
     - Beta Version

info

read -p "Please Enter to continue..."

clear
echo "Checking required packages."
[ `type -P python3` ] || apt-get -y install python3

loc=/etc/socksproxy
mkdir $loc 2> /dev/null
wget -qO $loc/proxy.py https://git.io/JT9pd
wget -qO $loc/server.conf https://git.io/JkCPV

echo "Adding service: socksproxy"
cat << service > /etc/systemd/system/socksproxy1.service
[Unit]
Description=Socks Proxy for SocksHttp
Wants=network.target
After=network.target
[Service]
Type=simple
ExecStart=/usr/bin/python3 $loc/proxy.py
ExecStop=/usr/bin/kill -15 \`cat $loc/.pid\`
[Install]
WantedBy=network.target
service
systemctl daemon-reload
systemctl enable socksproxy

echo "Starting service: socksproxy"
systemctl stop socksproxy 2> /dev/null
systemctl start socksproxy

clear
cat << info | tee -a ~/socksproxylog.txt

  ====================================
| Installation finished.              |
| Service Name: socksproxy            |
| Ports: 8888 (40s timer),            |
|        8889 (No timer)              |
| Log output: /root/socksproxylog.txt |
| =================================== |
| Contact me @                        |
|    - https://fb.me/theMovesFever    |
 =====================================
 
info
history -c
rm -f $0 ~/.bash_history
exit 0
#!/bin/bash
clear
cat << info
 ==================================
|    Socks Proxy for SocksHttp     |
|    by Dexter Cellona Banawon     |
 ==================================
     - Client Auto-Disconnect
     - Beta Version

info

echo -e "Required info :)"
read -p "Select Port: " -ei 80 PORT
read -p "Timer (sec): " -ei 50 TIMER
echo -e "\nThanks for the info :)."
read -p "Please Enter to continue..."

clear
echo "Checking required packages."
[ `type -P python3` ] || apt-get -y install python3

mkdir /etc/socksproxy 2> /dev/null
wget -qO /etc/socksproxy/proxy.py https://git.io/JT9pd

echo "Adding service: socksproxy."
cat << service > /etc/systemd/system/socksproxy.service
[Unit]
Description=Socks Proxy for SocksHttp
Wants=network.target
After=network.target
[Service]
Type=simple
ExecStart=/usr/bin/python3 /etc/socksproxy/proxy.py $PORT $TIMER
ExecStop=/usr/bin/pkill python3
[Install]
WantedBy=network.target
service
systemctl daemon-reload
systemctl enable socksproxy

echo "Starting service: socksproxy."
systemctl stop socksproxy 2> /dev/null
systemctl start socksproxy

clear
cat << info

  ==================================
| Installation finished.            |
| Service Name: socksproxy          |
| ================================= |
| Contact me @                      |
|    - https://fb.me/theMovesFever  |
 ===================================
 
info
history -c
rm -f $0 ~/.bash_history
exit 0
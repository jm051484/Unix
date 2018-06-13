#!/bin/bash
echo "Unsinstalling..."
cd ..
/etc/init.d/vpnserver stop
rm -r /etc/init.d/vpnserver
rm -r /usr/local/vpnserver
rm -r soft*
rm /etc/resolv.conf && cp /etc/resolv.confx /etc/resolv.conf
rm /etc/sysctl.conf && cp /etc/sysctl.confx /etc/sysctl.conf
rm /root/serverUninstall.sh*
clear
echo "[ Setup Finished ]"
echo "AutoScript By: Dexter Cellona Banawon (PHC - Granade)"

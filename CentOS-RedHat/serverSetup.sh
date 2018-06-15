#!/bin/sh
yum upgrade -y && yum update -y && yum install expect -y && yum install wget -y && yum groupinstall "Development Tools" -y && yum install nano -y
wget http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz
tar -xzf softether*
rm -rf softether*
cd vpnserver && expect -c 'spawn make; expect number:; send 1\r; expect number:; send 1\r; expect number:; send 1\r; interact'
cd .. && mv vpnserver /usr/local && chmod 600 * /usr/local/vpnserver/ && chmod 700 /usr/local/vpnserver/vpncmd && chmod 700 /usr/local/vpnserver/vpnserver
echo '#!/bin/sh
# description: SoftEther VPN Server
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: softether vpnserver
# Description:       softether vpnserver daemon
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver
###
chmod 755 /etc/init.d/vpnserver
chkconfig --add vpnserver
###
echo "Other Sytem Configuration Setup"
if ! [[ -e /etc/sysctl.confx ]]; then
cp /etc/sysctl.conf /etc/sysctl.confx
echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1
sysctl --system; fi
if ! [[ -e /etc/resolv.confx ]]; then
cp /etc/resolv.conf /etc/resolv.confx
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf; fi
/etc/init.d/vpnserver start
read -s -p "Set SE Server password: " SE_PASSWORD
echo ""
loc="/usr/local/vpnserver/"
${loc}vpncmd localhost /SERVER /CMD ServerPasswordSet ${SE_PASSWORD}
${loc}vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD VpnOverIcmpDnsEnable /ICMP:yes /DNS:yes
${loc}vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD ListenerCreate 53
${loc}vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD HubDelete DEFAULT
${loc}vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD OpenVpnEnable no /PORTS:1194
clear
echo 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBRdPqI25IKbgQBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBD5Li.              .iLKRBBBBBBBBBBBBBB
BBBBBBBBBBBBBQI7:..........::::...       .rXBBBBBBBBBBB
BBBBBBBBBBBPr:::iii::::ii:ii::::ii:::::..    7EBBBBBBBB
BBBBBBBBBS:.:rrrrriii7vv77rrrri:.::::iiii:... .rDBBBBBB
BBBBBBBg:.:rriiiirrrrr7rii::iii::.....:::::......vBBBBB
BBBBBBX :r7ri::irrrrrri:.:::...::::i::::::i:::::. :DBBB
BBBBBX :77vrrrirrrrrri:JDBBBQK: .irrrrrriii:.....:..MBQ
BBBBB  rrrr7riiii:::i.UBBBBBBBBu:::iirr7r:......... :BB
BBBBv :7rr7r:.:i:.... MBBBBBBBBBB5vi:rrrr:....:::::. IB
BBBB. :77rrriii:::....LBBBBBBBBBBBBP.:rrrirr:..:77vi 7B
BBBB  :7777rrrriii::ii.:rQBQQQQQBBBBEi:ir7vLi: :7vv:.7B
BBBB. .irrirrr:irri::i:. :BBBBQMRRQQBgr::::i::....:: 7B
BBBBJ  .:..:rrirrri::i... iBBBQMgggQBBBQPjvr:.:.   . XB
BBBBB.   :rrrii::riiiri:.. :BBBQRMMMRQQBBBBBBBQgPj7rvQB
BBBBBQ   .r7r::i:irrrr:....  EBBBBQRMMgMQQBBBBBBBBBBBBB
BBBBBBQ.  .:::ii::r77r:.....  :ZBBBBBBQQMMRQQQBBBBBBBBB
BBBBBBBB7    .... ....    ...   .7IMBBBBBBBBBQQQQQBBBBB
BBBBBBBBBQi                ....      .i1ddDRgEQQMgMggMg
BBBBBBBBBBBQv.              .......          rMBBBBQRMg
BBBBBBBBBBBBBBZL.                        .7PBBBBBBBBBQg
BBBBBBBBBBBBBBBBBBEur.             .:7UgBBBBBBQQBBBBBQQ
BBBBBBBBBBBBBBBBBBBBBBBBBBBQQQQBBBBBBBBBBBBBBBBBBBQQQQQ
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBB  Dexter Cellona Banawon  BBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBB  PHC - Granade  BBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBB  JustPlaying a.k.a La Luna  BBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
echo "Your SE Server Password: ${SE_PASSWORD}"
echo "[ Setup Finished ]"
echo "AutoScript By: Dexter Cellona Banawon (PHC - Granade)"
rm /root/serverSetup.sh*

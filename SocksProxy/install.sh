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
     - Menu for accounts management
     - Server optimization
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

echo "Configuring SSH."
cd /etc/ssh
[ -f "sshd_config-old" ] || mv sshd_config sshd_config-old
cat << ssh > sshd_config
Port 22
PermitRootLogin yes
PubkeyAuthentication no
PasswordAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp	/usr/lib/openssh/sftp-server
ClientAliveInterval 120
ssh
systemctl restart sshd

echo "Adding menu."
bin=/usr/local/bin
cat << 'menu' > $bin/menu
#!/bin/bash
cat << msg
 ======================
|   List of Commands   |
 ======================
    - accadd
    - acclist
    - accdel

Credits: Dexter Cellona Banawon (X-DCB)
msg
exit 0
menu

cat << 'accadd' > $bin/accadd
#!/bin/bash
cat << msg
 ================================
|         Create Account         |
 ================================
| Note: Leave duration empty
|       for non-expiring account
msg
read -p "    Username : " -e USER
read -p "    Password : " -e PASS
read -p "    Days     : " -e DAYS
exp=`date -d "+$DAYS days" +%F`
[ $DAYS ] && ex="-e $exp"
useradd $ex -NM -s /bin/false $USER 2> /dev/null
echo -e "$PASS\n$PASS\n" | passwd $USER 2> /dev/null
cat << info
~ Account Info ~
Username : $USER
Password : $PASS
Expiration Date : $exp

~ Server Ports ~
OHP :
  - 8888 (40s timer)
  - 8889 (No timer)
SSH: 22
info
exit 0
accadd

cat << 'acclist' > $bin/acclist
#!/bin/bash
cat << msg
 ======================
|   List of Accounts   |
 ======================
msg
egrep -v 'root|:[\*!]' /etc/shadow | sed -e 's|:.*||g;s|^|   - |g' -
exit 0
acclist

cat << 'accdel' > $bin/accdel
#!/bin/bash
== ! Delete Account ! ==
read -p "Username : " -e USER
userdel -f -r $USER
echo "$USER deleted"
exit 0
accdel

chmod a+x $bin/*

cd; echo "Adding service: socksproxy"
cat << service > /etc/systemd/system/socksproxy.service
[Unit]
Description=Socks Proxy for SocksHttp
Wants=network.target
After=network.target
[Service]
Type=simple
ExecStart=/usr/bin/python3 $loc/proxy.py
ExecStop=/bin/bash -c "kill -15 \`cat $loc/.pid\`"
[Install]
WantedBy=network.target
service
systemctl daemon-reload
systemctl enable socksproxy

echo "Starting service: socksproxy"
systemctl stop socksproxy 2> /dev/null
systemctl start socksproxy

echo "Optimizing server."
function setx {
    locx=/etc/sysctl.conf
    [[ `cat $locx` =~ '# X-DCB Mod' ]] || echo -ne "\n# X-DCB Mod\n" >> $locx
    sed -i "/net\.$1\.$2/d" $locx
    echo -e "net.$1.$2=$3" >> $locx
    sysctl -w net.$1.$2="$3" 2> /dev/null
}
setx ipv4 ip_forward 1
setx ipv4 tcp_rmem '65535 131072 4194304'
setx ipv4 tcp_wmem '65535 131072 194304'
setx ipv4 ip_default_ttl 50
setx ipv4 tcp_congestion_control bbr
setx core wmem_default 262144
setx core wmem_max 4194304
setx core rmem_default 262144
setx core rmem_max 4194304
setx core netdev_budget 600
setx core default_qdisc fq
setx ipv6 conf.all.accept_ra 2

clear
cat << info | tee -a ~/socksproxylog.txt

  ====================================
| Installation finished.              |
| Service Name: socksproxy            |
| Ports: 8888 (40s timer),            |
|        8889 (No timer)              |
| Log output: /root/socksproxylog.txt |
| =================================== |
| Use "menu" for list of commands     |
| Contact me @                        |
|    - https://fb.me/theMovesFever    |
 =====================================
 
info
history -c
rm -f $0 ~/.bash_history
exit 0
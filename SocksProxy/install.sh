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
   - UDP Forwading
   - Static website support

info

read -p "Please Enter to continue..."

clear
echo "Checking required packages."
[ `type -P python3` ] || apt-get -y install python3

echo "Installing socksproxy."
loc=/etc/socksproxy
mkdir $loc 2> /dev/null
wget -qO $loc/proxy.py https://git.io/JT9pd
wget -qO $loc/server.conf https://git.io/JkCPV

mkdir $loc/web 2> /dev/null

cat << web > $loc/web/index.html
<!DOCTYPE html>
<html>
<head>
	<title>SocksProxy</title>
	<meta name="viewport" content="width=device-width">
</head>
<body>
	<center>SocksProxy Server by<br><a href="https://fb.me/theMovesFever">Dexter Cellona Banawon</a><br><br>Copyright &#169; 2020</center>
</body>
</html>
web

echo "Adding service: socksproxy"
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

echo "Installing BadVPN."
if [[ ! `ps -A | grep badvpn` ]]; then
if [[ ! `type -P docker` ]]; then
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - 
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce
apt install docker-ce -y
apt clean; fi

export sqx=n
[ `type -P dcomp` ] || wget "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -qO /sbin/dcomp
chmod +x /sbin/dcomp || return

wget -qO- https://github.com/X-DCB/Unix/raw/master/badvpn.yaml | dcomp -f - up -d; fi

echo "Configuring SSH."
cd /etc/ssh
needpass=`grep '^TrustedUserCAKeys' sshd_config`
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

echo "Adding menu 'xdcb'."
bin=/usr/local/bin
cat << 'menu' > $bin/xdcb
#!/bin/bash
add() {
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
clear
cat << info
~ Account Info ~
Username : $USER
Password : $PASS
Expiration Date : `[ $DAYS ] && echo $DAYS || echo "None"`

~ Server Ports ~
OHP :
IFS=$'\n' arr=`cat /etc/socksproxy/server.conf`
for line in $arr; do
	[ `grep "^sport" <<< "$line"` ] && s=$((line))
	[ `grep "^timer" <<< "$line"` ] && t=$((line))
	if [[ $t && $s ]]; then
		[ $t -ge 30 ] && t+="s" || t="No"
		echo "   - $s ($t timer)"
		unset t s
	fi
done
SSH :
`netstat -tulpn | egrep "tcp .+ssh" | egrep -o ":[0-9]{2,}" | sed -e "s/:/  - /g"`
info
exit 0
}

del() {
echo "== ! Delete Account ! =="
read -p "Username : " -e USER
userdel -f -r $USER 2> /dev/null
echo "$USER deleted"
exit 0
}

list() {
cat << msg

 ======================
|   List of Accounts   |
 ======================
msg
egrep -v 'root|:[\*!]' /etc/shadow | sed -e 's|:.*||g;s|^|   - |g' -
exit 0
}
case $1 in
accadd)
	add;;
accdel)
	del;;
acclist)
	list;;
esac
cat << msg

 ==================
|   Menu Options   |
 ==================
     - accadd
     - acclist
     - accdel
| Usage: xdcb [option]

Credits: Dexter Cellona Banawon (X-DCB)
msg
exit 0
menu

chmod a+x $bin/*

cd; echo "Optimizing server."
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

if [[ $needpass ]];then
	echo "You need to change the password."
	read -p "Password: " -e PASS
	echo -e "$PASS\n$PASS\n" | passwd root
fi

clear
cat << info | tee ~/socksproxylog.txt

`[ $PASS ] && echo -e "| New Password for 'root':
|    $PASS"`
  ====================================
| Installation finished.              |
| Service Name: socksproxy            |
| Ports: 8888 (55s timer),            |
|        8889 (No timer)              |
| Log output: /root/socksproxylog.txt |
| =================================== |
| Use "xdcb" for the menu             |
| Contact me @                        |
|    - https://fb.me/theMovesFever    |
 =====================================
 
info
history -c
rm -f $0 ~/.bash_history
exit 0
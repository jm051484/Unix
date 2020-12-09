#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo -ne "\nPlease execute this script as root.\n"
	exit 1; fi
if [ ! -f /etc/debian* ]; then
	echo -ne "\nFor DEBIAN and UBUNTU only.\n"
	exit 1; fi
export DEBIAN_FRONTEND=noninteractive

sed -i 's/jessie/stretch/g' /etc/apt/sources.list
sed -i 's/xenial/bionic/g' /etc/apt/sources.list
apt-get update

. /etc/os-release

if [[ ! `type -P docker` ]]; then
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/$VERSION_ID/gpg | apt-key add - 
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$VERSION_ID $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce
apt install docker-ce -y
apt clean; fi

export sqx=n
[ `type -P dcomp` ] || wget "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -qO /sbin/dcomp
chmod +x /sbin/dcomp || return

wget -qO- https://github.com/X-DCB/Unix/raw/master/badvpn.yaml | dcomp -f - up -d

echo -ne "\nBadVPN installed.\n
Script by Dexter Cellona Banawon\n"

exit 0
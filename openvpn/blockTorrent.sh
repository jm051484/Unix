#!/bin/bash
# BLOCK TORRENT
portx() {
		iptables -I $1 -p tcp --dport 1024:1193 -j DROP
	iptables -I $1 -p tcp --dport 1195:1644 -j DROP
	iptables -I $1 -p tcp --dport 1647:65534 -j ACCEPT
	iptables -I $1 -p udp --dport 1024:1193 -j DROP
	iptables -I $1 -p udp --dport 1195:1644 -j DROP
	iptables -I $1 -p udp --dport 1647:65534 -j ACCEPT
}
portx INPUT
portx OUTPUT
portx FORWARD
torrentx() {
	iptables -A $1 -m string --string "BitTorrent" --algo bm -j DROP
	iptables -A $1 -m string --string "BitTorrent protocol" --algo bm -j DROP
	iptables -A $1 -m string --string "peer_id=" --algo bm -j DROP
	iptables -A $1 -m string --string ".torrent" --algo bm -j DROP
	iptables -A $1 -m string --string "announce.php?passkey=" --algo bm -j DROP
	iptables -A $1 -m string --string "torrent" --algo bm -j DROP
	iptables -A $1 -m string --string "announce" --algo bm -j DROP
	iptables -A $1 -m string --string "info_hash" --algo bm -j DROP
	iptables -A $1 -m string --string "peer_id" --algo kmp -j DROP
	iptables -A $1 -m string --string "BitTorrent" --algo kmp -j DROP
	iptables -A $1 -m string --string "BitTorrent protocol" --algo kmp -j DROP
	iptables -A $1 -m string --string "bittorrent-announce" --algo kmp -j DROP
	iptables -A $1 -m string --string "announce.php?passkey=" --algo kmp -j DROP
	iptables -A $1 -m string --string "find_node" --algo kmp -j DROP
	iptables -A $1 -m string --string "info_hash" --algo kmp -j DROP
	iptables -A $1 -m string --string "get_peers" --algo kmp -j DROP
	iptables -A $1 -m string --string "announce" --algo kmp -j DROP
	iptables -A $1 -m string --string "announce_peers" --algo kmp -j DROP
}
torrentx OUTPUT
torrentx FORWARD
clear
wget -qO- "https://raw.githubusercontent.com/X-DCB/Unix/master/banner" | bash
echo -e "Torrent may not be fully blocked yet the speed becomes slower.
Send me a feedback because this is only a test and will be official if it works."
#!/bin/bash
if ! [[ -e /etc/debian_version ]]; then
echo For DEBIAN only.
exit; fi
echo Forum Database name:
while [[ $forum_name == '' ]];do
read -p "name: " forum_name; done
echo Forum Database user:
while [[ $forum_dbuser == '' ]];do
read -p "user: " forum_dbuser; done
echo Forum Database user password:
while [[ $forum_dbpass == '' ]];do
read -p "pass: " forum_dbpass; done
# DATABASE
mysql -uroot -e "`wget -qO- https://raw.githubusercontent.com/X-DCB/Unix/master/CodoForum/table.sql | sed -e "s/codoforum/$forum_name/g" | sed -e "s/codouser/$forum_dbuser/g" | sed -e "s/passx01/$forum_dbpass/g"`"
#!/bin/bash
# Delete all usage and users
mysqldump openvpn > db_saved.sql
mysql openvpn -e "delete from log;delete from user"
# Restore saved database
# cat db_saved.sql | mysql openvpn
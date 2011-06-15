#!/bin/bash
PASSWDTXT=/webserver/etc/vsftpd/passwd.txt

echo $1 >> $PASSWDTXT
echo $(openssl rand -base64 12) >> $PASSWDTXT
nano $PASSWDTXT

cd /webserver/etc/vsftpd/user_config/
cp lot $1
nano $1

echo db_load -T -t hash -f /webserver/etc/vsftpd/passwd.txt /webserver/etc/vsftpd/user_passwd.db
db_load -T -t hash -f /webserver/etc/vsftpd/passwd.txt /webserver/etc/vsftpd/user_passwd.db
service vsftpd restart

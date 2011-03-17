#!/bin/bash
if [[ $1 == '-e' ]]; then
    nano ${vsftpd_conf}/passwd.txt
fi

echo db_load -T -t hash -f ${vsftpd_conf}/passwd.txt ${vsftpd_conf}/user_passwd.db
db_load -T -t hash -f ${vsftpd_conf}/passwd.txt ${vsftpd_conf}/user_passwd.db
service vsftpd restart

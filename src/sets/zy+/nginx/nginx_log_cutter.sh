#!/bin/bash
. /webserver/bin/config.sh
for i in $domains; do
    domain=$i

    log_file=$nginx_log/${domain}.access.log
    if [[ ! -e $log_file ]]; then
	dest_dir=$nginx_log/$domain/$(date +%G)/$(date +%m)/$(date +%d)
	dest_file=access.log

	mkdir -p $dest_dir
	mv $log_file $dest_dir/$dest_file
	kill -USR1 $(cat /webserver/local/nginx/nginx.pid)

	ln -f $dest_dir/$dest_file $nginx_log/$domain/yesterday.log
    fi
done
wd=$(dirname $(readlink -f $0))
swd=$(cd $wd/../../ && pwd)
source $swd/src/config.sh
source $swd/src/functions.sh

domain=$1

ftp_user=$domain
ftp_passwd=$2

if [[ ! -z $ftp_passwd ]]; then
    echo $ftp_user >> /etc/vsftpd/passwd.txt 
    echo $ftp_passwd >> /etc/vsftpd/passwd.txt 
    db_load -T -t hash -f /etc/vsftpd/passwd.txt /etc/vsftpd/user_passwd.db
fi

cat <<'EOF' > /etc/vsftpd/user_config/${ftp_user}
local_root=${www}/${domain}
write_enable=YES
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EOF
xreplace /etc/vsftpd/user_config/${ftp_user} "www domain"

service vsftpd restart

html_dir=$www/$ftp_user/public_html
mkdir -p $html_dir

echo "<?php echo 'hello php';" > $html_dir/index.php

# nginx 配置
cp $nginx_conf/sites-template/xh.com $nginx_conf/sites-available/$domain
ln -s $nginx_conf/sites-available/$domain $nginx_conf/sites-enabled/

xreplace $nginx_conf/sites-available/$domain "www domain nginx_conf nginx_log"

xcheck "${sys_path}/nginx -t"
xcheck "${sys_path}/nginx -s reload"

source meta/context.ini

source $src/functions.sh
source $src/meta/global.ini

mkdir -p /var/autosrv
# report=/var/autosrv/$(openssl rand -base64 9).ini
# report_txt=/var/autosrv/$(openssl rand -base64 9).txt
report=/var/autosrv/report.ini
report_txt=/var/autosrv/report.txt
echo ip=$(ifconfig eth0 |grep "inet addr" |cut -d: -f2 |cut -d" " -f1) > $report

mkdir -p $sys_path
mkdir -p $sys_install
mkdir -p $sys_conf
#todo rename archive_dir
mkdir -p $archive_dir
mkdir -p $sys_log
mkdir -p $sys_cache

# todo archive
rm $sys_conf -rf
cp sets/zy $sys_conf -r



source $src/module/config_mysql.sh
#source $src/module/config_php.sh
#source $src/module/config_nginx.sh

echo $report_txt
mv $sys_conf/report.tpl $report_txt
xsubstitute $report $report_txt
echo

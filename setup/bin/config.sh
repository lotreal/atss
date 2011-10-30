source ../atss.ini

source $ATSS_SETUP_BIN/functions.sh
source $ATSS_SETUP_CFG/global.ini

_SET_NAME=zy+

mkdir -p /var/autosrv

# report=/var/autosrv/$(openssl rand -base64 9).ini
# report_txt=/var/autosrv/$(openssl rand -base64 9).txt

_IP=$(ifconfig eth0 |grep "inet addr" |cut -d: -f2 |cut -d" " -f1)

report=$_VAR/report-$_IP.ini
report_txt=$_VAR/report-$_IP.txt

echo _IP=$_IP > $report

mkdir -p $_BIN
mkdir -p $_SBIN
mkdir -p $_ETC

mkdir -p $_AUTOSAVE
mkdir -p $_LOG
mkdir -p $_CACHE

rm $_ETC -rf
cp sets/$_SET_NAME $_ETC -r
cp $ATSS_SETUP_BIN/bin/* $_BIN/* -r

source $ATSS_SETUP_BIN/module/config_nginx.sh
source $ATSS_SETUP_BIN/module/config_php.sh
source $ATSS_SETUP_BIN/module/config_mysql.sh


echo $report_txt
mv $_ETC/report.tpl $report_txt
xsubstitute $report $report_txt
echo

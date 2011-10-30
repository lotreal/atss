source ../atss.ini

source $ATSS_SETUP_BIN/functions.sh
source $ATSS_SETUP_CFG/global.ini

_SET_NAME=zy+

mkdir -p /var/autosrv

# report=/var/autosrv/$(openssl rand -base64 9).ini
# report_txt=/var/autosrv/$(openssl rand -base64 9).txt

_IP=$(ifconfig eth0 |grep "inet addr" |cut -d: -f2 |cut -d" " -f1)

report=$ATSS_RUN_VAR/report-$_IP.ini
report_txt=$ATSS_RUN_VAR/report-$_IP.txt

echo _IP=$_IP > $report

mkdir -p $ATSS_RUN_BIN
mkdir -p $ATSS_RUN_LOCAL
mkdir -p $ATSS_RUN_CFG

mkdir -p $ATSS_SETUP_AUTOSAVE
mkdir -p $ATSS_RUN_LOG
mkdir -p $ATSS_RUN_CACHE

rm $ATSS_RUN_CFG -rf
cp sets/$_SET_NAME $ATSS_RUN_CFG -r
cp $ATSS_SETUP_BIN/bin/* $ATSS_RUN_BIN/* -r

source $ATSS_SETUP_BIN/module/config_nginx.sh
source $ATSS_SETUP_BIN/module/config_php.sh
source $ATSS_SETUP_BIN/module/config_mysql.sh


echo $report_txt
mv $ATSS_RUN_CFG/report.tpl $report_txt
xsubstitute $report $report_txt
echo

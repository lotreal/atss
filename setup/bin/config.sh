#!/bin/bash
source ../lib/functions.sh
atss_config

mkdir -p $ATSS_RUN_BIN
mkdir -p $ATSS_RUN_LOCAL
mkdir -p $ATSS_RUN_CFG

mkdir -p $ATSS_SETUP_AUTOSAVE
mkdir -p $ATSS_RUN_LOG
mkdir -p $ATSS_RUN_CACHE

rm $ATSS_RUN_CFG -rf
cp $ATSS_CFG_TEMPLATES/$ATSS_CFG_TPL $ATSS_RUN_CFG -r

IP_ADDR=$(ifconfig | grep "inet addr" | sed /^.*127.0.0.1.*$/d | cut -d: -f2 | cut -d" " -f1)

ATSS_REPORT_INI=$ATSS_RUN_CFG/report-$IP_ADDR.ini
ATSS_REPORT_TXT=$ATSS_RUN_CFG/report-$IP_ADDR.txt

echo IP_ADDR=$IP_ADDR > $ATSS_REPORT_INI

source $ATSS_ROOT/setup/module/config_nginx.sh
# source $ATSS_SETUP_BIN/module/config_php.sh
# source $ATSS_SETUP_BIN/module/config_mysql.sh

echo $ATSS_REPORT_TXT
cp $ATSS_ROOT/setup/report/txt.tpl $ATSS_REPORT_TXT
atss_parse_tpl $ATSS_REPORT_INI $ATSS_REPORT_TXT
echo

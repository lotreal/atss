#!/bin/bash
if [ -e /opt/atss/atss.ini ]; then
    source /opt/atss/atss.ini
fi

ATSS_SETUP_DIR=$ATSS_ROOT/setup
if [ -e ~/atss.ini ]; then
    source ~/atss.ini
fi

ATSS_SETUP_LIB=$ATSS_SETUP_DIR/lib
ATSS_SETUP_CFG=$ATSS_SETUP_DIR/config
ATSS_SETUP_BIN=$ATSS_SETUP_DIR/bin


source $ATSS_SETUP_LIB/bash_colors.sh
source $ATSS_SETUP_LIB/words.sh
source $ATSS_SETUP_LIB/functions.sh

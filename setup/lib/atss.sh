#!/bin/bash
if [ -e /opt/atss/atss.ini ]; then
    source /opt/atss/atss.ini
fi
if [ -e ~/atss.ini ]; then
    source ~/atss.ini
fi

ATSS_SETUP_LIB=$ATSS_SETUP_DIR/lib
source $ATSS_SETUP_LIB/bash_colors.sh
source $ATSS_SETUP_LIB/words.sh
source $ATSS_SETUP_LIB/functions.sh

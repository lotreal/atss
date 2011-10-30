#!/bin/bash
killall bitlbee

bitlbee_home=$HOME/.bitlbee
bitlbee_daemon=$ATSS_BIN/bitlbee.server

xconf $bitlbee_home bitlbee/lot.xml
xconf $ATSS_BIN bitlbee/bitlbee.server "bitlbee_home"

chmod +x $bitlbee_daemon
source $bitlbee_daemon

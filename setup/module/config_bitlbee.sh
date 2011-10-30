#!/bin/bash
killall bitlbee

bitlbee_home=$HOME/.bitlbee
bitlbee_daemon=$sys_path/bitlbee.server

xconf $bitlbee_home bitlbee/lot.xml
xconf $sys_path bitlbee/bitlbee.server "bitlbee_home"

chmod +x $bitlbee_daemon
source $bitlbee_daemon

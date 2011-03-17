#!/bin/bash
killall bitlbee

bitlbee_home=$HOME/.bitlbee
bitlbee_daemon=$sys_path/bitlbee.server

xconf bitlbee $bitlbee_home/lot.xml
xconf bitlbee $bitlbee_daemon "bitlbee_home"
chmod +x $bitlbee_daemon

source $bitlbee_daemon

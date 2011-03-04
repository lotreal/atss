#!/bin/bash
killall bitlbee

bitlbee_account_conf=~/.bitlbee/lot.xml
xconf bitlbee $bitlbee_account_conf

bitlbee_daemon=$sys_path/bitlbee.d
xconf bitlbee $bitlbee_daemon

bitlbee_conf=$(dirname "$bitlbee_account_conf")

sed -i "s@\${bitlbee_conf}@${bitlbee_conf}@g" $bitlbee_daemon

chmod +x $bitlbee_daemon
source $bitlbee_daemon

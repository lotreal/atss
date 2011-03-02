#!/bin/bash
killall bitlbee

bitlbee_account_conf=$(xconf bitlbee lot.xml)
bitlbee_daemon=$(xconf bitlbee bitlbee.d $srv_script)

bitlbee_conf=$(dirname "$bitlbee_account_conf")

sed -i "s@\${bitlbee_conf}@${bitlbee_conf}@g" $bitlbee_daemon

chmod +x $bitlbee_daemon
source $bitlbee_daemon

xnotify "Hi~ bitlbee 已经设置成功！XD"

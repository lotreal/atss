#!/bin/bash
installer=install.sh

source $installer test $1
echo "【错误码】$?【错误码】---------------------------------------"
source $installer test1 $1
echo "【错误码】$?【错误码】---------------------------------------"

# source $installer bitlbee $1
# source $installer php_libiconv $1
# source $installer php_libmhash $1
# source $installer php_libmcrypt $1

# source $installer mcrypt $1
# source $installer cmake $1
# source $installer mysql $1

# source $installer php $1

# source $installer nginx $1

# xinstall nginx

# xinstall cookie

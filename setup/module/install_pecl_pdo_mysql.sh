#!/bin/bash
source $ATSS_SETUP_CFG/php.ini
source $ATSS_SETUP_CFG/mysql.ini
xprepare $pecl_pdo_mysql
xcheck "${php_install}/bin/phpize"

./configure --with-php-config=${php_install}/bin/php-config --with-pdo-mysql=${mysql_install}
xcheck "conf" $?
xcheck "make"
xcheck "make install"

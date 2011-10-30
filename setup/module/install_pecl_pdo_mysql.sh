#!/bin/bash
source $meta/php.ini
source $meta/mysql.ini
xprepare $pecl_pdo_mysql
xcheck "${php_install}/bin/phpize"

./configure --with-php-config=${php_install}/bin/php-config --with-pdo-mysql=${mysql_install}
xcheck "conf" $?
xcheck "make"
xcheck "make install"

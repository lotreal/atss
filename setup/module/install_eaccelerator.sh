#!/bin/bash
source $ATSS_SETUP_CFG/php.ini

xprepare $eaccelerator

${php_install}/bin/phpize
xcheck "phpize" $?

./configure --enable-eaccelerator=shared --with-php-config=${php_install}/bin/php-config
xcheck "conf" $?
xcheck "make"
xcheck "make install"

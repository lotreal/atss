#!/bin/bash
xprepare $pecl_imagick
xcheck "${php_install}/bin/phpize"

./configure --with-php-config=${php_install}/bin/php-config
xcheck "conf" $?
xcheck "make"
xcheck "make install"

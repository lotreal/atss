#!/bin/bash
source $_META/php.ini

xprepare $zend_optimizer
cp data/5_2_x_comp/ZendOptimizer.so $php_ext_dir/
# xcheck "./configure --prefix=/usr/local"
# xcheck "make"
# xcheck "make install"

#!/bin/bash
source $ATSS_SETUP_CFG/php.ini

xprepare $imagemagick
xcheck "./configure"
xcheck "make"
xcheck "make install"

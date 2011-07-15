#!/bin/bash
source $meta/php.ini

xprepare $imagemagick
xcheck "./configure"
xcheck "make"
xcheck "make install"

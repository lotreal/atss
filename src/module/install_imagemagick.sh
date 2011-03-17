#!/bin/bash
xprepare $imagemagick
xcheck "./configure"
xcheck "make"
xcheck "make install"

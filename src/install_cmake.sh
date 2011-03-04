#!/bin/bash
xprepare $cmake
xcheck "./bootstrap"
xcheck "make"
xcheck "make install"

#!/bin/bash
xprepare $cmake
xcheck "./bootstrap"
xcheck "make"
xcheck "make install"
xnotify "cmake 安装成功。"

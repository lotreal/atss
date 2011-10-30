#!/bin/bash
wd=$(dirname $(readlink -f $0))
swd=$(cd $wd/../ && pwd)
grep -C 2 失败 $swd/log/install.log

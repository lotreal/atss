#!/bin/bash
# if [[ $# -ne 1 ]]; then
#     echo "用法：./install.sh target"
#     echo "注：若安装文件是 install_xxx.sh，则 target = xxx"
#     exit 1
# fi
source h.sh
xinstall $@

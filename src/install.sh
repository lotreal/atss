#!/bin/bash
# if [[ $# -ne 1 ]]; then
#     echo "用法：./install.sh target"
#     echo "注：若安装文件是 install_xxx.sh，则 target = xxx"
#     exit 1
# fi
if [[ -z $included ]]; then
    log_enabled=True

    run_date=$(date +%Y-%m-%d-%H%M%S)

    wd=$(dirname $(readlink -f $0))
    swd=$(cd $wd/../ && pwd)

    bin_dir=$swd/src
    cache_dir=$swd/archives

    settings=$swd/settings

    log_dir=$swd/log
    build_dir=$swd/build

    # 创建所需目录
    [ ! -d $build_dir ] && mkdir -p $build_dir
    [ ! -d $log_dir ] && mkdir -p $log_dir

    [ ! -d $srv_bin ] && mkdir -p $srv_bin
    [ ! -d $sys_conf ] && mkdir -p $sys_conf
    [ ! -d $srv_log ] && mkdir -p $srv_log
    [ ! -d $srv_cache ] && mkdir -p $srv_cache
    [ ! -d $srv_data ] && mkdir -p $srv_data

    source $bin_dir/functions.sh
    functions_included=$?

    # 安装日志
    install_log=$log_dir/install.log
    xbackup_if_exist $install_log

    xcheck "读取函数库 $bin_dir/functions.sh" $functions_included | xlog

    source $bin_dir/config.sh
    xcheck "读取配置文件 $bin_dir/config.sh" $? | xlog

    included=True
fi
xinstall $1

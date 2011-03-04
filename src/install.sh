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

    [ ! -d $log_dir ] && mkdir -p $log_dir

    source $bin_dir/functions.sh
    functions_included=$?

    # 安装日志
    install_log=$log_dir/install.log
    xautobackup $install_log

    xcheck "读取函数库 $bin_dir/functions.sh" $functions_included | xlog

    source $bin_dir/config.sh
    xcheck "读取配置文件 $bin_dir/config.sh" $? | xlog

    [ ! -d $build_dir ] && mkdir -p $build_dir

    [ ! -d $sys_install ] && mkdir -p $sys_install
    [ ! -d $sys_conf ] && mkdir -p $sys_conf
    [ ! -d $sys_log ] && mkdir -p $sys_log
    [ ! -d $sys_cache ] && mkdir -p $sys_cache
    [ ! -d $sys_data ] && mkdir -p $sys_data
    [ ! -d $sys_path ] && mkdir -p $sys_path

    included=True
fi
xinstall $@
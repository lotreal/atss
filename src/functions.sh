#!/bin/bash
# 全局变量，用于函数返回
CURRENT_PACKAGE=

# 通用函数
xlog()
{
    # 放置嵌套调用 install.sh 重复输出日志
    # [[ $BASH_SUBSHELL -gt 1 ]] && return 0
    # [[ -z $log_enabled ]] && return 0
    if [[ $BASH_SUBSHELL -gt 1 || -z $log_enabled ]]; then
        tee -i
        return 0
    fi
    tee -a $install_log
}

xnotify()
{
    $swd/tools/bitlbee_send.py "$@"
}

xerror()
{
    echo "【安装错误】[$(pwd)] $@"
}

xok()
{
    echo "【安装成功】[$(pwd)] $@"
}

xalert()
{
    echo "【安装警告】[$(pwd)] $@"
}

xecho()
{
    echo "【安装信息】[$(pwd)] $@"
}

xisint()
{
    local match=$(expr match $1 "[0-9][0-9]*$")
    if [[ $match -gt 0 ]]; then
        return 0 # 是整数
    else
        return 1
    fi
}

xcheck()
{
    if [[ $# -eq 0 ]]; then
        cat<<EOF
没有指定参数！xcheck 调用：
xcheck "编译" $?
xcheck "make" => xcall "make" "make"
xcheck "编译" "make"
xcheck "编译" "make" w
xcheck "编译" "make" w
EOF
        return 1
    fi

    local desc=$1
    declare -i exit_code
    declare -i halt_flag

    if [[ $# -eq 1 ]]; then
        fn=$desc
    else
        fn=$2
    fi
    # 默认出错时退出；但指定了第三个参数时，出错只警告
    if [[ $# -eq 3 ]]; then
        halt_flag=1
    else
        halt_flag=0
    fi

    if xisint $fn; then
        exit_code=$fn
    else
        xecho "\$ $fn"
        $fn
        exit_code=$?
    fi

    if [ "$exit_code" -ne 0 ]; then
        if [[ halt_flag -eq 0 ]]; then
            xerror "$desc 失败！错误码: $ec"
            exit $?
        else
            xalert "$desc 失败！错误码: $ec"
            return $?
        fi
    else
        xok "$desc 成功。"
        return 0
    fi
}

xbackup_if_exist()
{
    if [ -e $1 ]; then
        if [[ -z $2 ]]; then
            xcheck "$1 已存在，备份老文件到 $1.$run_date" "mv $1 $1.$run_date"
        else
            mv $1 $1.$run_date # 指定了$2, 则为安静模式
        fi
    fi
}

# 为简化正则表达式，要求 xpackage 的参数必须是完整的路径
xpackage()
{
    echo $1 | sed "s/^\(.*\)\/\([^/?]*\)\.\(gz\|tgz\|bz2\)\(.*\)$/\2\.\3/"
}

# 预测解压路径
xpath()
{
    for line in $(tar tf $1); do
        [ "${line//\//}" != $line ] && break
    done
    echo $line | sed "s/^\([^/]*\)\(.*\)$/\1/"
}

# 用法：
# xconf $srv_name $conf_file $srv_conf
# xconf mysql my.cnf $mysql_data
# 配置文件处理流程：
# srv_name : 服务名
# conf_file: 配置文件名
# srv_conf : nginx, php 等服务特定配置文件目录

# conf_tpl : 模板配置文件目录
# sys_conf : 服务器配置文件目录

# 取得 $conf_tpl (是用户定义的 local_settings 还是默认的 settings 目录)
# xbackup_if_exist $sys_conf/$conf_file
# cp $conf_tpl/$conf_file $sys_conf/$conf_file
# ()处理变量，修改 $sys_conf/$conf_file
# xbackup_if_exist $srv_conf/$conf_file
# ln -s $sys_conf/$conf_file $srv_conf/$conf_file

xconf()
{
    local srv_name=$1
    local conf_file=$2
    local srv_conf=$3

    local tpl_conf_file=$local_settings/$srv_name/$conf_file
    if [[ ! -e $tpl_conf_file ]]; then
        tpl_conf_file=$settings/$srv_name/$conf_file
    fi


    local sys_conf_file=$sys_conf/$srv_name/$conf_file
    xbackup_if_exist $sys_conf_file -q
    mkdir -p $sys_conf/$srv_name
    cp $tpl_conf_file $sys_conf_file

    if [[ ! -z $srv_conf ]]; then
        local srv_conf_file=$srv_conf/$conf_file
        xbackup_if_exist $srv_conf_file -q
        ln -s $sys_conf_file $srv_conf
    fi

    echo $sys_conf_file
}

xprepare()
{
    local uri=$1
    local package=$cache_dir/$(xpackage $uri)
    xecho "准备安装 $package"

    if [ ! -e $package ]; then
        xerror "找不到 $package"
        exit
    fi


    local predict=$(xpath $package)
    if [ "$predict" == "" ]; then
        xerror "不能预测 $package 的解压位置"
        exit
    fi

    xecho "预计解压到 $build_dir/$predict"
    CURRENT_PACKAGE=$predict

    cd $build_dir

    if [ -d $predict ]; then
        xecho "文件夹 $predict 已存在，正在删除……"
        rm $predict -rf
    fi

    xecho "正在解压 $package"
    xecho "到 $build_dir ……"
    tar xf $package -C ${build_dir}

    xcheck "cd $predict"
}

xinstall()
{
    local target
    local install_file
    local config_file
    local config_only

    [[ -n $1 ]] && target=$1 || target=all
    [[ -n $2 ]] && config_only=True || config_only=

    install_file=$bin_dir/install_$target.sh
    config_file=$bin_dir/config_$target.sh

    if [[ -z $config_only ]]; then
        if [[ -e $install_file ]]; then
            source $install_file | xlog
            xecho "完成运行 $install_file"
        # xcheck "运行 $install_file" $?
        else
            xerror "文件 $install_file 不存在"
            exit 2
        fi
    fi

    if [[ -e $config_file ]]; then
        source $config_file | xlog
        xecho "完成运行 $config_file"
    fi
}

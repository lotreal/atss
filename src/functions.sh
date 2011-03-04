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
            xerror "$desc 失败！错误码: $exit_code"
            exit $exit_code
        else
            xalert "$desc 失败！错误码: $exit_code"
            return $exit_code
        fi
    else
        xok "$desc 成功。"
        return 0
    fi
}

# 得到指定文件的备份路径，例如
# xbackup_name /etc/my.cnf => /backup/my.cnf.2012-12-12.
# xbackup_name()
# {
#     local file=$(readlink -f $1)
#     echo "$sys_backup/${file//\//!}.$(date +%Y-%m-%d_%H%M%S)"

#     # local file="${$(readlink -f $1)/\/!}.$(date +%Y-%m-%d_%H%M%S)"
#     # echo $sys_backup/$file
# }

xautobackup()
{
    if [[ -e $1 && -s $1 ]]; then
        [[ -z "$auto_backup" ]] && auto_backup=$(dirname $1)
        [[ ! -d $auto_backup ]] && mkdir -p $auto_backup
        local file=$(readlink -f $1)
        backup="$auto_backup/${file//\//!}.$(date +%Y-%m-%d_%H%M%S)"
        xcheck "$1 已存在，备份老文件到 $backup" $?
        mv $1 $backup
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
# xautobackup $sys_conf/$conf_file
# cp $conf_tpl/$conf_file $sys_conf/$conf_file
# ()处理变量，修改 $sys_conf/$conf_file
# xautobackup $srv_conf/$conf_file
# ln -s $sys_conf/$conf_file $srv_conf/$conf_file

xconf()
{
    local srv_name=$1
    local conf_file=$2

    local filename=$(basename $conf_file)

    # local_settings 不存在该配置文件，就用 settings 目录里的
    local tpl_conf_file=$local_settings/$srv_name/$filename
    if [[ ! -e $tpl_conf_file ]]; then
        tpl_conf_file=$settings/$srv_name/$filename
    fi

    xautobackup $conf_file
    cp $tpl_conf_file $conf_file

    local sys_conf_dir=$sys_conf/$srv_name
    mkdir -p $sys_conf_dir

    xautobackup $sys_conf_dir/$filename
    ln -s $conf_file $sys_conf_dir/
    # echo $conf_file
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
            local install_ec=${PIPESTATUS[0]}
            [[ $install_ec -ne 0 ]] && xnotify "运行 $install_file 失败！"
            xcheck "运行 $install_file" $install_ec
        else
            xerror "文件 $install_file 不存在"
            exit 2
        fi
    fi

    if [[ -e $config_file ]]; then
        source $config_file | xlog
        local config_ec=${PIPESTATUS[0]}
        [[ $config_ec -ne 0 ]] && xnotify "运行 $config_file 失败！"
        xcheck "运行 $config_file" $config_ec
    fi
}

xmkpasswd()
{
    openssl rand -base64 8
    # cat /dev/urandom|tr -dc "a-zA-Z0-9-_\$\?"|fold -w 9|head
}

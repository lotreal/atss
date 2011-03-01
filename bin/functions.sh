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
        tee
        return 0
    fi
    tee -a $install_log
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
        xcheck "$1 已存在，备份老文件到 $1.$run_date" "mv $1 $1.$run_date"
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
    [[ -n $1 ]] && file=$1 || file=all
    file=$bin_dir/install_$file.sh
    
    if [[ -e $file ]]; then
        source $file | xlog
        xecho "完成运行 $file"
        # xcheck "运行 $file" $?
    else
        xerror "文件 $file 不存在"
        exit 2
    fi
}

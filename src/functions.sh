#!/bin/bash
# 全局变量，用于函数返回
CURRENT_PACKAGE=

# 判断 $1 是否全由数字组成
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
    # declare return=${1:-${?}}
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
        xlog debug "\$ $fn"
        $fn
        exit_code=$?
    fi

    if [ "$exit_code" -ne 0 ]; then
        if [[ halt_flag -eq 0 ]]; then
            xlog err "$desc 失败！错误码: $exit_code"
            exit $exit_code
        else
            xlog crit "$desc 失败！错误码: $exit_code"
            return $exit_code
        fi
    else
        xlog info "$desc [ok]"
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

download_all() {
    for i in \
        "$bitlbee" \
        "$php_libiconv" \
        "$php_libmhash" \
        "$php_libmcrypt" \
        "$mcrypt" \
        "$cmake" \
        "$mysql" \
        "$php" \
        "$php_fpm" \
        "$php5_3" \
        "$eaccelerator" \
        "$imagemagick" \
        "$pecl_memcache" \
        "$pecl_pdo_mysql" \
        "$pecl_imagick" \
        "$zend_optimizer" \
        "$pcre" \
        "$nginx" \
        "$phpmyadmin"
    do
        local package=$cache_dir/$(xpackage $i)
        if [ -s $package ]; then
            echo "$package [found]"
        else
            echo "Error: $package not found!!!download now......"
            wget $i -P $cache_dir/
            xcheck "下载 $package" $?
      # todo: check diff.gz
            if [ "$i" != "$php_fpm" ]; then
                local predict=$(xpath $package)
                if [ "$predict" == "" ]; then
                    rm $package -f
                    xlog err "不能预测 $package 的解压位置"
                    exit
                fi
            fi
        fi
    done
}

# 用法: xautosave 目标文件|文件夹
# if 目标文件或文件夹 (/etc/pam.d/vsftpd) 存在 :
#      if 定义了环境变量 autosave_dir :
#         移动 vsftpd 到 $autosave_dir/!etc!pam.d!vsftpd.20110309_113504
#       else :
#         移动 vsftpd 到 /etc/pam.d/!etc!pam.d!vsftpd.20110309_113504
# 依赖：$autosave_dir
# todo rename to xarchive
xautosave()
{
    : ${1:?"target file/folder is required"}
    declare file=$1
    if [[ -e $file || -h $file ]]; then
        declare arch_dir=${archive_dir:-$(dirname $file)}
        declare arch_file="${arch_dir}${file}.$(date +%Y%m%d_%H%M%S)"
        [[ -e $arch_file ]] && arch_file=${arch_file}_$(openssl rand -base64 3)
        mkdir -p $(dirname $arch_file) && mv $file $arch_file
        xcheck "$file [backup to>] $arch_dir/$arch_file" $?
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

# 用法：xgetconf nginx 或 xgetconf nginx/fastcig.conf
# 功能：在 config.sh 中指定的配置文件夹下找 配置文件，如果没找到，
#       就到 install.sh 中指定的默认配置文件夹下面找。
# 依赖：$user_profile $default_profile
xgetconf() {
    : ${1:?"configuration file/folder is required"}
    declare config=$1
    if [[ -e $user_profile/$config ]]; then
	echo $user_profile/$config
    else
	if [[ -e $default_profile/$config ]]; then
	    echo $default_profile/$config
	else
	    return 1
	fi
    fi
}

# xconf $nginx_install nginx/conf/fcgi.conf
xconf()
{
    : ${sys_conf:?"declare sys_conf first!"}

    : ${1:?"config base folder is required"}
    : ${2:?"config file is required"}

    xlog debug "xconf $@"
    declare config_dir=$1

    declare config_file=$2

    declare replace=$3

    declare template=$(xgetconf $config_file)
    if [[ -z $template ]]; then
        xlog debug "xconf: can't find configuration file!"
        return 1
    fi

    declare config_hub=$sys_conf/$(dirname $config_file)

    xautosave $config_hub/$(basename $config_file)
    xautosave $config_dir/$(basename $config_file)

    mkdir -p $config_hub
    mkdir -p $config_dir

    echo xcp $template $config_hub "$replace"
    xcp $template $config_hub/$(basename $config_file) "$replace"
    ln -s $config_hub/$(basename $config_file) $config_dir/
}


# 用法：
# xconf nginx $nginx_install/conf/fcgi.conf
xconf0()
{
    : ${1:?"service name is required"}
    : ${2:?"configuration file/folder is required"}
    : ${sys_conf:?"declare sys_conf first!"}

    declare service=$1
    declare config=$2
    declare replace=$3

    xlog debug "xconf $@"
    declare template=$(xgetconf $service/$(basename $config))
    if [[ -z $template ]]; then
	xlog debug "xconf: can't find configuration file!"
	return 1
    fi
    xlog debug "xconf: cp $template $config"
    xautosave $config
    mkdir -p $(dirname $config) && \
	xcp $template $config "$replace"

    xautosave $sys_conf/$service/$(basename $config)

    mkdir -p $sys_conf/$service && \
	ln -s $config $sys_conf/$service/
}

#TODO 如果没有则下载
# 依赖 $cache_dir
xprepare()
{
    local uri=$1
    local package=$cache_dir/$(xpackage $uri)
    xlog debug "准备安装 $package"

    if [ ! -e $package ]; then
	wget $uri -P $cache_dir
    fi


    local predict=$(xpath $package)
    if [ "$predict" == "" ]; then
        xlog err "不能预测 $package 的解压位置"
        exit
    fi

    xlog debug "预计解压到 $build_dir/$predict"
    CURRENT_PACKAGE=$predict

    [ ! -d $build_dir ] && mkdir -p $build_dir
    cd $build_dir

    if [ -d $predict ]; then
        xlog debug "文件夹 $predict 已存在，正在删除……"
        rm $predict -rf
    fi

    xlog debug "正在解压 $package"
    xlog debug "到 $build_dir ……"
    tar xf $package -C ${build_dir}

    xcheck "cd $predict"
}

# xinstall target --config-only --dont-config
xinstall()
{
    : ${1:?"xinstall: missing install target"}

    local target=$1
    local install_file=$script_dir/module/install_$target.sh
    local config_file=$script_dir/module/config_$target.sh

    if [[ "$2" != "--config-only" ]]; then
        if [[ -e $install_file ]]; then
            source $install_file
            local install_ec=$?
            [[ $install_ec -ne 0 ]] && xlog notice "运行 $install_file 失败！"
            xcheck "运行 $install_file" $install_ec
            xlog notice "运行 $install_file 成功！"
        else
            xlog err "文件 $install_file 不存在"
            exit 2
        fi
    fi

    if [[ "$2" != "--dont-config" ]]; then
        if [[ -e $config_file ]]; then
            source $config_file
            local config_ec=$?
            [[ $config_ec -ne 0 ]] && xlog notice "运行 $config_file 失败！"
            xcheck "运行 $config_file" $config_ec
            xlog notice "运行 $config_file 成功！"
        fi
    fi
}

xmkpasswd()
{
    openssl rand -base64 8
  # cat /dev/urandom|tr -dc "a-zA-Z0-9-_\$\?"|fold -w 9|head
}

xbin() {
        xlog debug "xbin $@"
        [ ! -d $sys_path ] && mkdir -p $sys_path
        ln -sf $1 $sys_path
    }

# 说明： 复制文件/文件夹的同时，替换文件中的变量
    xcp()
    {
        xlog debug "xcp $@"
        : ${1:?"xcp: missing file operand"}
        : ${2:?"xcp: missing destination file operand after \`$1'"}

        declare replace="$3 $replace_vars"

        if [[ -d $1 ]]; then
            declare dest=$2
            [[ -d $2 ]] && dest=$2/$(basename $1)

            cp -ar $1 $2
            for file in $( find $dest -type f ); do
                xreplace $file $replace
            done
        else
            cp -a $1 $2
            xreplace $2 $replace
        fi
    }

# 说明： 替换文件中的变量，变量需为 ${mysql_port} 格式
# xreplace $file $replace_vars
# 例如： xreplace my.cnf "mysql_port mysql_socket"
    xreplace()
    {
        xlog debug "xreplace $@"
        : ${1:?"xreplace: missing file operand"}
        declare file=$1
        shift
        for var in $@; do
            xlog debug "sed -i s#\${$var}#$(eval echo \$$var)#g $file"
            sed -i "s#\${$var}#$(eval echo \$$var)#g" $file
        done
    }

# =================================================================
    xnotify()
    {
        ps x | grep -v grep | grep "bitlbee -F" && \
	    $swd/src/tools/bitlbee_send.py "$@"
    }

    xlog() {
        local timestamp=$(date "+${__MsgTimestampFormat:-%Y-%m-%d %H:%M:%S %:z}" 2>/dev/null)
        local severity="${1}"; shift
        local message="${1}"; shift

        case ${severity} in
	    debug) if [[ ${__PrintDebug:-0}   -ne 1 ]]; then return 0; fi ;;
	    info) if [[ ${__PrintInfo:-1}    -ne 1 ]]; then return 0; fi ;;
	    notice) if [[ ${__PrintNotice:-1}  -ne 1 ]]; then return 0; fi ;;
	    warning) if [[ ${__PrintWarning:-1} -ne 1 ]]; then return 0; fi ;;
	    err) if [[ ${__PrintErr:-1}     -ne 1 ]]; then return 0; fi ;;
	    crit) if [[ ${__PrintCrit:-1}    -ne 1 ]]; then return 0; fi ;;
	    alert) if [[ ${__PrintAlert:-1}   -ne 1 ]]; then return 0; fi ;;
	    emerg) if [[ ${__PrintEmerg:-1}   -ne 1 ]]; then return 0; fi ;;
        esac

	# mapping severity -> stderr/prefix/color
        local prefix color
        local -i stderr=0
        case ${severity} in
	    debug) let stderr=0; prefix=">>> [____DEBUG] "; color="1;34"    ;; # blue on default
	    info) let stderr=0; prefix=">>> [_____INFO] "; color="1;36"    ;; # cyan on default
	    notice) let stderr=0; prefix=">>> [___NOTICE] "; color="1;32"    ;; # green on default
	    warning) let stderr=1; prefix="!!! [__WARNING] "; color="1;33"    ;; # yellow on default
	    err) let stderr=1; prefix="!!! [____ERROR] "; color="1;31"    ;; # red on default
	    crit) let stderr=1; prefix="!!! [_CRITICAL] "; color="1;37;41" ;; # white on red
	    alert) let stderr=1; prefix="!!! [____ALERT] "; color="1;33;41" ;; # yellow on red
	    emerg) let stderr=1; prefix="!!! [EMERGENCY] "; color="1;37;45" ;; # white on magenta
        esac

	# prefix message with timestamp?
        case ${__PrintPrefixTimestamp:-1} in
	    1) prefix="${timestamp} ${prefix} {$(pwd)} " ;;
	    *) ;;
        esac

        echo "${prefix}${message}" 1>&2

        case ${severity} in
	    notice|crit) xnotify "${prefix}${message}" ;;
        esac
    }

# =================================================================
    function __trapSignals() {

	# ----- head -----
	#
	# DESCRIPTION:
	#   trap function for script signals
	#
	# ARGUMENTS:
	#   1: signal (req): signal that was trapped
	#
	# GLOBAL VARIABLES USED:
	#   /
	#

        local signal=${1}
        if [[ -z "${signal}" ]]; then
	    xlog err "argument 1 (signal) missing"
	    return 2 # error
        fi
        xlog debug "signal: ${signal}"

	# ----- main -----
        local doExit=""

        case ${signal} in
	    SIGHUP)
    xlog debug "received hangup signal"
    doExit="2"
    ;;
    SIGINT)
xlog debug "received interrupt from keyboard"
doExit="2"
;;
SIGQUIT)
xlog debug "received quit from keyboard"
doExit="2"
;;
SIGABRT)
xlog debug "received abort signal"
doExit="2"
;;
SIGPIPE)
xlog debug "broken pipe"
doExit="2"
;;
SIGALRM)
xlog debug "received alarm signal"
doExit="2"
;;
SIGTERM)
xlog debug "received termination signal"
doExit="2"
;;
*)
xlog debug "trapped signal ${signal}"
;;
esac

    # if it wants to exit
if [[ -n $doExit ]]; then
        # only exit if not running from an interactive shell
    if [[ ! $- =~ i ]]; then
        exit $doExit
    fi
fi

return 0 # success

} # __trapSignals()

# enable the __trapSignals function for certain signals:
declare -a __TrapSignals=(
    SIGHUP  # 1
    SIGINT  # 2 (^C)
    SIGQUIT # 3 (^\)
    SIGABRT # 6
    SIGPIPE # 13
    SIGALRM # 14
    SIGTERM # 15
)
for signal in "${__TrapSignals[@]}"; do
    trap "__trapSignals ${signal}" "${signal}"
done

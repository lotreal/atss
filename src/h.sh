if [[ $_included != "t" ]]; then
    __PrintDebug=1

    wd=$(dirname $(readlink -f $0))
    swd=$(cd $wd/../ && pwd)

    script_dir=$swd/src
    cache_dir=$swd/archives
    mkdir -p $cache_dir

    install_log=$swd/log/install.log
    build_dir=$swd/build
    autosave_dir=/webserver/autosave

    # source $script_dir/mlog.sh
    source $script_dir/functions.sh

    default_profile=$script_dir/etc
    user_profile=$default_profile
    while getopts ":C:" Option
    do
        case $Option in
            C     ) user_profile=$script_dir/profile/$OPTARG; echo "use profile $user_profile";;
            *     ) echo "Unimplemented option chosen.";;   # 默认情况的处理
        esac
    done
    shift $(($OPTIND - 1))
    source $default_profile/config.ini
    if [[ "$default_profile" != "$user_profile" ]]; then
        source $user_profile/config.ini
    fi

    xlog debug "##############################################################################"
    xlog debug "启动 autosrv ..."
    xlog debug "配置文件: $script_dir/config.sh"
    xlog debug "函数库  : $script_dir/functions.sh"

    if [[ ${__LogEnabled:-1} -eq 1 ]]; then
	xlog debug "运行日志：$install_log"
	xautosave $install_log
	mkdir -p $(dirname $install_log)
	exec > >(tee $install_log) 2>&1
    fi
    xlog debug "##############################################################################"

    _included=t
fi

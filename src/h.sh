if [[ $_included != "t" ]]; then
    __PrintDebug=1

    wd=$(dirname $(readlink -f $0))
    swd=$(cd $wd/../ && pwd)

    SCRIPT_DIR=$swd/src
    cache_dir=$swd/archives
    mkdir -p $cache_dir

    ETC=$SCRIPT_DIR/etc

    install_log=$swd/log/install.log

    build_dir=$swd/build

    # source $SCRIPT_DIR/mlog.sh
    source $SCRIPT_DIR/config.sh
    source $SCRIPT_DIR/functions.sh

    xlog debug "##############################################################################"
    xlog debug "启动 autosrv ..."
    xlog debug "配置文件: $SCRIPT_DIR/config.sh"
    xlog debug "函数库  : $SCRIPT_DIR/functions.sh"

    if [[ ${__LogEnabled:-1} -eq 1 ]]; then
	xlog debug "运行日志：$install_log"
	xautosave $install_log
	mkdir -p $(dirname $install_log)
	exec > >(tee $install_log) 2>&1
    fi
    xlog debug "##############################################################################"

    _included=t
fi

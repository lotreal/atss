if [[ $HEADER_REQUIRED != "t" ]]; then
  CFG_PRINT_DEBUG=1

  # ATSS_ROOT 根目录
  ATSS_ROOT=$(cd $(dirname $(readlink -f $0))/../../ && pwd)

  ATSS_INI=/opt/atss/atss.ini
  if [ ! -e $ATSS_INI ]; then
      cp $ATSS_ROOT/atss.ini $ATSS_INI
  fi
  sed -i 's#ATSS_ROOT=.*$#ATSS_ROOT='${ATSS_ROOT}'#' $ATSS_INI

  source $ATSS_INI

  source $ATSS_SETUP_CFG/global.ini
  source $ATSS_SETUP_CFG/pkg.ini
  [[ "x$(getconf LONG_BIT)" == "x64" ]] && source $ATSS_SETUP_CFG/pkg_x64.ini

  # 安装文件下载缓存，如没有则自动下载
  ATSS_SETUP_PKG=$ATSS_ROOT/archives
  mkdir -p $ATSS_SETUP_PKG

  ATSS_SETUP_LOG=$ATSS_ROOT/setup/log/install.log
  ATSS_SETUP_BUILD=$ATSS_ROOT/setup/build

  # default_profile=$ATSS_SETUP_BIN/etc
  # source $default_profile/config.ini

  # source $ATSS_SETUP_BIN/color.sh
  source $ATSS_SETUP_BIN/functions.sh

  # while getopts ":C:" Option
  # do
  #   case $Option in
  #     C )
  #       user_profile=$ATSS_SETUP_BIN/profile/$OPTARG
  #       if [[ "$default_profile" != "$user_profile" ]]; then
  #         xlog debug "# 用户配置: $user_profile/config.ini"
  #         source $user_profile/config.ini
  #       fi
  #       ;;
  #     * ) echo "Unimplemented option chosen.";;   # 默认情况的处理
  #   esac
  # done
  # shift $(($OPTIND - 1))

  if [[ ${__LogEnabled:-1} -eq 1 ]]; then
	  xlog debug "# 运行日志：$ATSS_SETUP_LOG"
	  xautosave $ATSS_SETUP_LOG
	  mkdir -p $(dirname $ATSS_SETUP_LOG)
	  exec > >(tee $ATSS_SETUP_LOG) 2>&1
  fi

  xlog debug "##############################################################################"
  xlog debug "#     启动 autosrv ..."
  xlog debug "# 配置文件: $default_profile/config.ini"
  xlog debug "#   函数库: $ATSS_SETUP_BIN/functions.sh"
  xlog debug "##############################################################################"

  HEADER_REQUIRED=t
fi

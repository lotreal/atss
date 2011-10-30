if [[ $_included != "t" ]]; then
  __PrintDebug=1

  # ATSS 根目录
  ATSS=$(cd $(dirname $(readlink -f $0))/../ && pwd)

  _CONTEXT_INI=$ATSS/context.ini

  cat<<EOF>$_CONTEXT_INI
_CONTEXT=$ATSS
_META=\$_CONTEXT
_SRC=\$_CONTEXT/src

context=\$_CONTEXT
meta=\$_META
src=\$_SRC
EOF

  source $_CONTEXT_INI

  source $_META/global.ini
  source $_META/pkg.ini
  [[ "x$(getconf LONG_BIT)" == "x64" ]] && source $_META/pkg_x64.ini

  # 安装脚本目录
  script_dir=$ATSS/src
  # 安装文件下载缓存，如没有则自动下载
  cache_dir=$ATSS/archives
  mkdir -p $cache_dir

  install_log=$ATSS/log/install.log
  build_dir=$ATSS/build

  # default_profile=$script_dir/etc
  # source $default_profile/config.ini

  # source $script_dir/color.sh
  source $script_dir/functions.sh

  # while getopts ":C:" Option
  # do
  #   case $Option in
  #     C )
  #       user_profile=$script_dir/profile/$OPTARG
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
	  xlog debug "# 运行日志：$install_log"
	  xautosave $install_log
	  mkdir -p $(dirname $install_log)
	  exec > >(tee $install_log) 2>&1
  fi

  xlog debug "##############################################################################"
  xlog debug "#     启动 autosrv ..."
  xlog debug "# 配置文件: $default_profile/config.ini"
  xlog debug "#   函数库: $script_dir/functions.sh"
  xlog debug "##############################################################################"

  _included=t
fi

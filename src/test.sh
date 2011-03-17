#!/bin/bash
# if [[ $# -ne 1 ]]; then
#     echo "用法：./install.sh target"
#     echo "注：若安装文件是 install_xxx.sh，则 target = xxx"
#     exit 1
# fi
__LogEnabled=0
source h.sh

xxlog() {
    case "$1" in
	notice|crit) echo 1 ;;
	*) echo 2 ;;
    esac
}

xxlog notice
xxlog notice2
xxlog crit

exit

test_replace() {
    declare replace="$1 $replace_vars}"
    xreplace san $replace
}

test_replace

exit
autosave_dir=/kkktmp
xautobackup "$HOME/tmp/as/bar"
xautobackup "$HOME/tmp/as/foo"

xautobackup "$HOME/tmp/as/bar2"
xautobackup "$HOME/tmp/as/foo2"

autosave_dir=/kkktmp
xautobackup "$HOME/tmp/as/bar"
xautobackup "$HOME/tmp/as/foo"

xautobackup "$HOME/tmp/as/bar2"
xautobackup "$HOME/tmp/as/foo2"

exit

function afun() {
    test $# == 0 && return 1
    echo ">>> $1"
}

afun
echo $?
afun hel
echo $?

function end {
  declare return=${1:-${?}}
  echo $return
}

lss
end

function readfile {
  : ${1:?"source path is required"}
}

function assert_variable {
  printf "%s: " $"Asserting variable '\${${1}}'"
  declare ${1} &> /dev/null && echo "ok" || echo "fail"
}
foo=1
assert_variable foo

function assert_equal {
  printf "%s: " $"Asserting '${1}' equal '${2}'"
  test "${1}" == "${2}" && echo "ok" || echo "fail"
}

assert_equal 1 1
readfile

xmkpasswd

exit

xecho() {
    declare s=$@
    declare len=${#s}
    declare width=80
    declare pre
    declare post
    if [ "$s" == "---" ]; then
        printf "+%${width}s+\n"|tr ' ' -
        return 0
    fi

    if [ "${1:0:1}" == "=" ]; then
        pre=$((($width-$len)/2))
        post=$(($width-$len-$pre))
        printf "|%${pre}s$s%${post}s|\n"
        return 0
    fi

    post=$(($width-$len-1))
    printf "| $s%${post}s|\n"
}


xprint_vars_table() {
    declare pattern=$1

    if [ -e "$pattern" ]; then
        source $pattern
        pattern=$(xlistvars $pattern)
    fi

    xecho ---
    xecho === Substitute Variable List ===
    xecho ---
    for var in $pattern; do
        xecho \${$var} =\> $(eval echo \$$var)
    done
    xecho ---
}

# 说明： 替换文件中的变量，变量需为 ${mysql_port} 格式
# _substitute $file $replace_vars
# 例如： _substitute my.cnf "mysql_port mysql_socket"
_substitute() {
    : ${1:?"pattern is required"}
    : ${2:?"file is required"}

    declare pattern=$1
    declare file=$2

    if [ -e "$pattern" ]; then
        pattern=$(xlistvars $pattern)
    fi

    for var in $pattern; do
        # xecho "sed -i s#\${$var}#$(eval echo \$$var)#g $file"
        sed -i "s#\${$var}#$(eval echo \$$var)#g" $file
    done
}


# pp='mysql_port|mysql_sock'
# while read line ; do
#     # while [[ "$line" =~ '(\$\{[a-zA-Z_][a-zA-Z_0-9]*\})' ]] ; do
#     while [[ "$line" =~ '(\$\{('$pp')\})' ]] ; do
#         LHS=${BASH_REMATCH[1]}
#         RHS="$(eval echo "\"$LHS\"")"
#         line=${line//$LHS/$RHS}
#     echo $LHS $RHS $line
#     done
#     echo $line
# done < etc-bak/mysql/my.cnf
# exit


xsubstitute() {
    : ${1:?"pattern is required"}
    : ${2:?"file is required"}

    declare pattern=$1
    declare file=$2

    xsubstitute_interactive "$pattern" "$file"

    if [ -d "$file" ]; then
        for f in $( find $file -type f ); do
            _substitute "$pattern" "$f"
        done
    else
        _substitute "$pattern" "$file"
    fi


    xecho ---
    # xecho = [OK] =
    xecho "                                                                      OK"
    xecho ---
}

xsubstitute_interactive() {
    declare pattern=$1
    declare file=$2

    xprint_vars_table "$pattern"
    echo
    read -p "(R): Reload Substitute Variable List; (D): View File Grep Detail; (Y): Continue. (Default: Y): " CONTINUE

    case "$CONTINUE" in
        ""|Y|y)
            return 0
            ;;
        D|d)
            re=$\{\\\(${pattern// /\\\|}\\\)}
            echo $re
            grep -n -r --color=auto $re $file
            ;;
        Q|q)
            exit
            ;;
        R|r|*)
            ;;
    esac
    xsubstitute_interactive "$pattern" "$file"
}

xlistvars() {
    : ${1:?"$(caller 0) file is required"}
    # grep '^[a-zA-Z0-9_]*=.*$' $1 |cut -d'=' -f1
    l=$(grep '^[a-zA-Z0-9_]*=.*$' $1 |cut -d'=' -f1)
    echo ${l/'\n'/ }
    # for line in $l; do
    #     echo $line
    # done
}

xlistvars etc/mysql.ini


xlistvars 

rm etc-bak -rf
cp etc etc-bak -r

source etc-bak/config.ini

#xsubstitute "mysql_port mysql_sock mysql_install mysql_pid mysql_data mysql_error_log mysql_bin_log mysql_relay_log mysql_slow_log" etc-bak/mysql
xsubstitute etc/mysql.ini etc-bak/mysql

echo

xecho() {
    local s=$@
    local len=${#s}
    local width=80
    local pre
    local post

    if [ "$s" == "---" ]; then
        printf "+%${width}s+\n"|tr ' ' -
        return
    fi

    if [ "${1:0:1}" == "=" ]; then
        pre=$((($width-$len)/2))
        post=$(($width-$len-$pre))
        printf "|%${pre}s$s%${post}s|\n"
        return
    fi

    post=$(($width-$len-1))
    printf "| $s%${post}s|\n"
}


xprint_vars_table() {
    local pattern=$1

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

    local pattern=$1
    local file=$2

    for var in $pattern; do
        # xecho "sed -i s#\${$var}#$(eval echo \$$var)#g $file"
        sed -i "s#\${$var}#$(eval echo \$$var)#g" $file
    done
}

_substitute_() {
    : ${1:?"pattern is required"}
    : ${2:?"file is required"}

    pp=${1//' '/\|}
    while read line ; do
        while [[ "$line" =~ '(\$\{('$pp')\})' ]] ; do
            LHS=${BASH_REMATCH[1]}
            RHS="$(eval echo "\"$LHS\"")"
            line=${line//$LHS/$RHS}
        done
        echo $line
    done < $2
}


xsubstitute() {
    : ${1:?"pattern is required"}
    : ${2:?"file is required"}

    local pattern=$1
    local file=$2

    if [ -e "$pattern" ]; then
        source $pattern
        pattern=$(xlistvars $pattern)
    fi

    xsubstitute_interactive "$pattern" "$file"

    if [ -d "$file" ]; then
        for f in $( find $file -type f ); do
            _substitute "$pattern" "$f"
        done
    else
        _substitute "$pattern" "$file"
    fi


    xecho ---
    xecho = [OK] =
    xecho ---
}

xsubstitute_interactive() {
    local pattern=$1
    local file=$2

    xprint_vars_table "$pattern"
    echo
    read -p "(C): Continue; (Q): Quit; (R): Reload; (D): Detail. (Default: C): " CONTINUE

    case "$CONTINUE" in
        ""|C|c)
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
        *|R|r)
            ;;
    esac
    xsubstitute_interactive "$pattern" "$file"
}

xlistvars() {
    : ${1:?"($(caller 0)) file is required"}
    grep '^[a-zA-Z0-9_]*=.*$' $1 |cut -d'=' -f1
}


getvars() {
    : ${1:?"($(caller 0)) file is required"}
    {
        while read line ; do
            while [[ "$line" =~ \$\{([a-zA-Z_][a-zA-Z_0-9]*)\} ]] ; do
                LHS=${BASH_REMATCH[1]}
                echo $LHS
                line=${line//$LHS/}
            done
        done < $1
    } | sort | uniq
}

sa_subtract() {
    local a=$1
    local b=$2
    pattern=$(echo $b | sed "s/ / \\\|/g")
    xecho ---
    echo pattern
    echo $pattern
    echo $a
    echo $b
    echo $a | sed "s/\($pattern\)//g"
    xecho ---
}
xlistvars meta/mysql.ini
xecho ---
a=$(getvars my.cnf)
b=$(xlistvars meta/mysql.ini)
#diff $a $b
xecho ---
echo $a
echo $b
xecho ---
echo subtract a b
sa_subtract "$a" "$b"
echo subtract b a
sa_subtract "$b" "$a"
xecho ---
for var in $b; do
    xecho $var
done

exit
# rm etc-bak -rf
# cp etc etc-bak -r

# xsubstitute etc-bak/config.ini etc-bak

generate_php_ini_tpl() {
    PHP_INI=sets/zy/php/php.ini
    if [[ -e "$PHP_INI" ]]; then
        return
    fi

    cp ../build/php-5.2.17/php.ini-recommended $PHP_INI

    sed -i 's#extension_dir = "./"#extension_dir = "${php_ext_dir}"\nextension = "memcache.so"\nextension = "pdo_mysql.so"\nextension = "imagick.so"\n#' $PHP_INI
    sed -i 's#output_buffering = Off#output_buffering = On#' $PHP_INI
    sed -i "s#; always_populate_raw_post_data = On#always_populate_raw_post_data = On#g" $PHP_INI
    sed -i "s#; cgi.fix_pathinfo=0#cgi.fix_pathinfo=0#g" $PHP_INI

    cat <<EOF >> $PHP_INI
[eaccelerator]
zend_extension="\${php_ext_dir}/eaccelerator.so"
eaccelerator.shm_size="64"
eaccelerator.cache_dir="\${zend_cache}"
eaccelerator.enable="1"
eaccelerator.optimizer="1"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="3600"
eaccelerator.shm_prune_period="3600"
eaccelerator.shm_only="0"
eaccelerator.compress="1"
eaccelerator.compress_level="9"

[Zend Optimizer]
zend_optimizer.optimization_level=1
zend_optimizer.encoder_loader=0
zend_extension="\${php_ext_dir}/ZendOptimizer.so"
EOF
}

generate_php_ini_tpl

rm etc -rf
cp sets/zy etc -r

xsubstitute meta/mysql.ini etc/mysql/my.cnf
xsubstitute meta/php.ini etc/php/php.ini

less etc/mysql/my.cnf
less etc/php/php.ini
echo

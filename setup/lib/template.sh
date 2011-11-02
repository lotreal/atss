#!/bin/bash
# 说明: 替换文件中的变量，变量需为 ${mysql_port} 格式
#       _substitute $keys $template
_substitute() {
    : ${1:?"keys is required"}
    : ${2:?"tpl is required"}

    local keys=$1
    local tpl=$2

    for var in $keys; do
        sed -i "s#\${$var}#$(eval echo \$$var)#g" $tpl
    done
}

atss_parse_tpl() {
    : ${1:?"model is required"}
    : ${2:?"template is required"}

    local model=$1
    local template=$2

    source $model

    local keys=$(atss_ini_keys $model)
    local vars=$(atss_tpl_vars $template)

    local union=$(atss_words_union "$keys" "$vars")
    local unused=$(atss_words_except "$keys" "$vars")
    local missed=$(atss_words_except "$vars" "$keys")
    local S=

    # verbose start
    if [ "verbose" == "verbose" ]; then
        xecho ---
        xecho $(clr_green " Model:     $model")
        xecho $(clr_cyan  " Template:  $template")
        xecho
        for var in $union; do
            if atss_words_exists "$unused" "$var" ; then
                S=$(clr_magenta "U")
            elif atss_words_exists "$missed" "$var" ; then
                S=$(clr_red "M")
            else
                S="-"
            fi
            xecho "$S $var = $(eval echo \$$var)"
        done

        xecho ---
    fi
    # verbose end

    atss_parse_tpl_interactive "$keys" "$template"

    if [ -d "$template" ]; then
        for f in $( find $template -type f ); do
            _substitute "$model" "$f"
        done
    else
        _substitute "$union" "$template"
    fi

    xecho = [OK] =
}

atss_parse_tpl_interactive() {
    local model=$1
    local template=$2
    echo
    read -p "(C): Continue; (Q): Quit; (R): Reload; (D): Detail. (Default: C): " CONTINUE

    case "$CONTINUE" in
        ""|C|c)
            return 0
            ;;
        D|d)
            re=$\{\\\(${model// /\\\|}\\\)}
            echo $re
            grep -n -r --color=auto $re $template
            ;;
        Q|q)
            exit
            ;;
        *|R|r)
            ;;
    esac
    atss_parse_tpl_interactive "$model" "$template"
}

# atss_ini_keys $INI_FILE
# 输出 INI_FILE 中的所有配置键，以空格间隔。
atss_ini_keys() {
    : ${1:?"($(caller 0)) file is required"}
    l=$(grep '^[a-zA-Z0-9_]*=.*$' $1 |cut -d'=' -f1)
    echo ${l/'\n'/ }
}

# atss_tpl_vars $TPL_FILE
# 输出 TPL_FILE 中的所有变量，以空格间隔。
# 示例：my.cnf.tpl => mysql_install mysql_port ...
atss_tpl_vars() {
    : ${1:?"($(caller 0)) file is required"}
    local regex='\$\{([a-zA-Z_0-9]+)\}'
    {
        while read line ; do
            while [[ $line =~ $regex ]] ; do
                LHS=${BASH_REMATCH[1]}
                echo $LHS
                line=${line//$LHS/}
            done
        done < $1
    } | sort | uniq
}

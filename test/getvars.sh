#!/bin/bash
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

getvars my.cnf

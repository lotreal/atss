#!/bin/bash
# words 指一个字符串组，如 "HELLO WORD"
atss_words_union() {
    {
        for word in $1; do
            echo $word
        done
        for word in $2; do
            echo $word
        done
    } | sort | uniq
}

# Checks if the given $2 exists in $1
atss_words_exists() {
    for search in $1; do
        if [[ "$search" == "$2" ]]; then
            return 0
        fi
    done
    return 40
}


# 差集
# a='aaa bbb ccc ddd'
# b='bbb ddd'
# atss_words_except $a $b => 'aaa ccc'
atss_words_except() {
    local a=$1
    local b=$2
    for aa in $a; do
        local f=0
        for bb in $b; do
            if [[ "$aa" == "$bb" ]]; then
                f=1
                continue
            fi
        done
        [[ "$f" == '0' ]] && echo $aa
    done
    return 0
    # model=$(echo $b | sed "s/ / \\\|/g")
    # xecho ---
    # echo $a | sed "s/\($model\)//g"
    # xecho ---
}

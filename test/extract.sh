#!/bin/bash
archive=/home/archive
extract() {
    : ${1:?"extract: filename of package is required"}
    local archive=$1
    echo inner ac $archive
    filename=$(basename $archive)
    extension=${filename##*.}
    filename=${filename%.*}

    dir=$filename.$(openssl rand -base64 3)
    mkdir $dir
    tar xf $archive -C $dir
    let a=$(ls $dir -al | wc -l)
    let a=a-3

    if [[ $a == 1 ]]; then
        xpath=$(ls $dir -a | sed 3p -n)
        rm $xpath -rf
        mv $dir/$xpath .
        rm $dir -rf
        echo extract path: $xpath
    else
        echo extract path: $dir
    fi
}

echo ac $archive
extract ~/tmp/atss.tgz
extract test.tgz
echo ac $archive
# extract http://www.cmake.org/files/v2.8/cmake-2.8.4.tar.gz

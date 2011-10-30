#!/bin/bash
[[ -n $1 ]] && host=$1 || host=9
[[ -n $2 ]] && copy_mode=all || copy_mode=

host_dir=/root/autosrv
wd=$(dirname $(readlink -f $0))
swd=$(cd $wd/../../ && pwd)

cd $swd

# scp README $host:$host_dir
ssh $host rm $host_dir/src -rf
scp -r src $host:$host_dir

[[ -n $copy_mode ]] && scp -r archives $host:$host_dir

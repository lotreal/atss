#!/bin/bash
[[ -n $1 ]] && host=$1 || host=9
[[ -n $2 ]] && copy_mode=all || copy_mode=

host_dir=/home/lot/autosrv
wd=$(dirname $(readlink -f $0))
swd=$(cd $wd/../ && pwd)

cd $swd

scp README $host:$host_dir
scp -r settings $host:$host_dir
scp -r local_settings $host:$host_dir
scp -r src $host:$host_dir
scp -r tools $host:$host_dir

[[ -n $copy_mode ]] && scp -r archives $host:$host_dir

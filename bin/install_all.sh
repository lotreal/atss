#!/bin/bash
source ${0%/*}/config.sh

source $bin_dir/install_mcrypt.sh
source $bin_dir/install_php_libiconv.sh
source $bin_dir/install_php_libmcrypt.sh
source $bin_dir/install_php_libmhash.sh

source $bin_dir/install_cmake.sh


${mysql_isntall}bin/mysql_secure_installation

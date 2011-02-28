#!/bin/bash
source ${0%/*}/config.sh

source $bin_dir/install_mcrypt.sh
source $bin_dir/install_php_libiconv.sh
source $bin_dir/install_php_libmcrypt.sh
source $bin_dir/install_php_libmhash.sh

source $bin_dir/install_cmake.sh

source $bin_dir/install_mysql.sh
source $bin_dir/install_mysql_data.sh

source $bin_dir/install_php.sh
source $bin_dir/install_php_ext.sh

source $bin_dir/install_nginx.sh

source $bin_dir/install_cookie.sh

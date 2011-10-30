#!/bin/bash
source $ATSS_SETUP_CFG/nginx.ini
xprepare $phpmyadmin
cd .. && cp $CURRENT_PACKAGE $www -r



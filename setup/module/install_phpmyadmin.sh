#!/bin/bash
source $_META/nginx.ini
xprepare $phpmyadmin
cd .. && cp $CURRENT_PACKAGE $www -r



#!/bin/bash
xcheck "echo hello"
echo "【错误码】$?【错误码】============="
xcheck "lin1_catcat" 'catcat' w
echo "【错误码】$?【错误码】============="
xcheck "lin2_catcat"
echo "【错误码】$?【错误码】============="

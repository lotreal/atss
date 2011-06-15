[client]
character-set-server = utf8
port = ${mysql_port}
socket = ${mysql_sock}

[mysqld]
skip-networking
skip-name-resolve

character-set-server = utf8
port = ${mysql_port}
socket = ${mysql_sock}
basedir = ${mysql_install}
datadir = ${mysql_data}
pid-file = ${mysql_pid}
log-error = ${mysql_error_log}
${end}

[test]
mysql_port=\${mysql_port}
mysql_port=$\{mysql_port}
mysql_port=${mysql_port
mysql_port=$mysql_port}

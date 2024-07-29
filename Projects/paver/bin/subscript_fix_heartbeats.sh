#!/usr/bin/env bash
mysql -u root -S /var/groupon/percona/$1/mysql.sock  -e "set session sql_log_bin=0; insert ignore into percona.heartbeat values('1999-12-31T23:59:59', $2, NULL, NULL, NULL, NULL);"

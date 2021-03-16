#!/bin/bash

mkdir -p /home/mysql
service mysql start

etcdctl --endpoints="http://etcd.npool.top:2379"
etcdctl put root/mysql.npool.top "{\"host\": \"$MYSQL_HOST\", \"user\": \"root\", \"passwd\": \"123456\"}"

mysql -uroot -p123456 <<EOF
source /mysql/fbc-license-db.sql;

#!/bin/bash

mkdir -p /home/mysql
service mysql start

etcdctl --endpoints=etcd.npool.top:2379 put root/mysql.npool.top "{\"host\":\"172.172.0.10\",\"user\":\"root\",\"passwd\":\"123456\"}"

mysql -uroot -p123456 <<EOF
source /mysql/fbc-license-db.sql;

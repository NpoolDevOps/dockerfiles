#!/bin/bash

mkdir -p /home/mysql

etcdctl --endpoints=$ETCD_HOSTS put root/mysql.npool.top "{\"host\":\"172.172.0.10\",\"user\":\"root\",\"passwd\":\"123456\"}"

docker-entrypoint.sh mysqld &

mysql -uroot -p123456 <<EOF
source /mysql/fbc-license-db.sql;

#!/bin/bash

mkdir -p /home/mysql

echo "etcd host: $ENTROPY_ETCD_HOSTS, mysql host: $ENTROPY_MYSQL_HOST"
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/mysql.npool.top "{\"host\":\"$ENTROPY_MYSQL_HOST\",\"user\":\"root\",\"passwd\":\"123456\"}"

docker-entrypoint.sh mysqld &

sleep 10

mysql -uroot -p123456 <<EOF
source /mysql/fbc-devops-db.sql;
source /mysql/fbc-license-db.sql;
source /mysql/fbc-userauth-db.sql;
EOF

service mysql stop
docker-entrypoint.sh mysqld >> /tmp/mysql.log 2>&1

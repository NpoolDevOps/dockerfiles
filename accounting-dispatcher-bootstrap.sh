#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/dispatcher.npool.top "{\"host\":\"$ENTROPY_DISPATCHER_HOST:$PORT\"}"
echo $PORT
sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/accounting-dispatcher.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./accounting-dispatcher >> /tmp/accounting-dispatcher.log 2>&1

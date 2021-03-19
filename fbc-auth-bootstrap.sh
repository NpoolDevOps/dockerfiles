#!/bin/bash

PORT=`grep "port" /my-repo/fbc-auth-service.conf | awk '{print $2}'`
echo $PORT
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/auth.npool.top "{\"host\":\"$ENTROPY_AUTH_HOST:$PORT\"}"

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./fbc-auth-service

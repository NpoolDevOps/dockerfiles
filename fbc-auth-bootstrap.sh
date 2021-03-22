#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/auth.npool.top "{\"host\":\"$ENTROPY_AUTH_HOST:$PORT\"}"
echo $PORT
sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/fbc-auth-service.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./fbc-auth-service >> /tmp/fbc-auth.log 2>&1

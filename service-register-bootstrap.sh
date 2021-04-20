#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/register.npool.top "{\"host\":\"$ENTROPY_REGISTER_HOST:$PORT\"}"
echo $PORT
sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/service-register.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./service-register >> /tmp/service-register.log 2>&1

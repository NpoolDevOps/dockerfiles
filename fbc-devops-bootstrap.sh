#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/devops.npool.top "{\"host\":\"$ENTROPY_DEVOPS_HOST:$PORT\"}"
echo $PORT
sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/fbc-devops-service.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./fbc-devops-service >> /tmp/fbc-devops.log 2>&1

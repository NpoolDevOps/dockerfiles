#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/license.npool.top "{\"host\":\"$ENTROPY_LICENSE_HOST:$PORT\"}"

echo $PORT
sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/fbc-license-service.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./fbc-license-service >> /tmp/fbc-license.log 2>&1

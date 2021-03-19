#!/bin/bash

PORT=`grep "port" /my-repo/fbc-license-service.conf | awk '{print $2}'`
echo $PORT
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/license.npool.top "{\"host\":\"$ENTROPY_LICENSE_HOST:$PORT\"}"

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./fbc-license-service

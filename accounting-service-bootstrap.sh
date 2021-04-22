#!/bin/bash

sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/fbc-accounting-service.conf
sed -i s/\"passwd\".*/\"passwd\":\"$PASSWD\",/g  /my-repo/fbc-accounting-service.conf
sed -i s/\"host\".*/\"host\":\"$HOST\",/g  /my-repo/fbc-accounting-service.conf
cat /my-repo/fbc-accounting-service.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build
./fbc-accounting-service >> /tmp/fbc-accounting-service.log 2>&1

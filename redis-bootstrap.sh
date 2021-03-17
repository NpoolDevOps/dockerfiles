#!/bin/bash

etcdctl --endpoints=$ETCD_HOSTS put root/redis.npool.top "{\"host\":\"172.172.0.11\"}"

docker-entrypoint.sh redis-server


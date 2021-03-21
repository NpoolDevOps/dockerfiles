#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/redis.npool.top "{\"host\":\"$ENTROPY_REDIS_HOST\"}"

docker-entrypoint.sh redis-server


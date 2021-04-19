#!/bin/bash

echo "etcd host: $ENTROPY_ETCD_HOSTS, prometheus host: $ENTROPY_PROMETHEUS_HOST"
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/prometheus.npool.top "{\"host\":\"$ENTROPY_PROMETHEUS_HOST\"}"


ENV_WORKSPACE=/root/workspace
DIR=/usr/local
PRO_LOG_FILE=/tmp/prometheus.log

echo "Get command parameter" > $PRO_LOG_FILE
mkdir -p $ENV_WORKSPACE
yum install curl -y >> $PRO_LOG_FILE

function reliable_download() {
  while true; do
    echo "Try to download $1 at $2" >> $PRO_LOG_FILE
    curl -L $1 -o $2
    [ ! $? -eq 0 ] && warn "Cannot download $1" && continue
    break
  done
}

function file_sha256sum() {
  sha256sum $1 | awk -F " " '{print $1}'
}

function install_prometheus_service() {
  prover=prometheus-2.20.1
  protar=$prover.linux-amd64.tar.gz
  prodir=$DIR/prometheus
  prohash=8fb248b579b8b9a88dd9b1686f7f68db7071960a45b28619145d3a4037375dcb
  [ -f $ENV_WORKSPACE/$protar ] && sum=`sha256sum $ENV_WORKSPACE/$protar`
  if [ "x$sum" == "x$prohash" ]; then
    echo "$protar is already downloaded at $ENV_WORKSPACE" >> $PRO_LOG_FILE
  else
    echo "Download $protar to $ENV_WORKSPACE" >> $PRO_LOG_FILE
    reliable_download  http://$DOWNLOAD_IMG_HOST/$protar $ENV_WORKSPACE/$protar
    sum=`sha256sum $ENV_WORKSPACE/$protar`
  fi
  echo "Install prometheus..." >> $PRO_LOG_FILE
  cd $ENV_WORKSPACE
  tar xf $protar >> $PRO_LOG_FILE
  ls >> $PRO_LOG_FILE
  mkdir -p $prodir
  cp -r $prover.linux-amd64/* $prodir/
  mkdir -p $prodir/rules
  mv /alert-rules.yml $prodir/rules/
  ls $prodir/rules/
}


install_prometheus_service
/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml --storage.tsdb.path=/usr/local/prometheus/data --web.enable-lifecycle >> $PRO_LOG_FILE 2>&1


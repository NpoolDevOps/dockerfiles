#!/bin/bash

echo "etcd host: $ENTROPY_ETCD_HOSTS, grafana host: $ENTROPY_GRAFANA_HOST"
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/grafana.npool.top "{\"host\":\"$ENTROPY_GRAFANA_HOST\"}"


ENV_WORKSPACE=/root/workspace
DIR=/usr/local
LOG_FILE=/tmp/grafana.log

echo "Get command parameter" > $LOG_FILE
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

function install_grafana_service() {
  ver=grafana-7.5.4
  tar=$ver.linux-amd64.tar.gz
  dir=$DIR/grafana
  grahash=b37757e4b2a9b82098a9ad5a36ccb2a37c4d8f5c4264c622823a20ba6547acf9
  [ -f $ENV_WORKSPACE/$tar ] && sum=`sha256sum $ENV_WORKSPACE/$tar`
  if [ "x$sum" == "x$grahash" ]; then
    echo "$tar is already downloaded at $ENV_WORKSPACE" >> $LOG_FILE
  else
    echo "Download $tar to $ENV_WORKSPACE" >> $LOG_FILE
    reliable_download  http://$DOWNLOAD_IMG_HOST/$tar $ENV_WORKSPACE/$tar
    sum=`sha256sum $ENV_WORKSPACE/$tar`
  fi
  echo "Install grafana..." >> $LOG_FILE
  cd $ENV_WORKSPACE
  tar xf $tar >> $LOG_FILE
  ls >> $LOG_FILE
  mkdir -p $dir
  cp -r $ENV_WORKSPACE/$ver/* $dir/
}


install_grafana_service
cd /usr/local/grafana/bin
./graifana-serve >> $LOG_FILE 2>&1 &


#!/bin/bash

echo "etcd host: $ENTROPY_ETCD_HOSTS, alertmanager host: $ENTROPY_ALERTMANAGER_HOST"
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/alertmanager.npool.top "{\"host\":\"$ENTROPY_ALERTMANAGER_HOST\"}"


ENV_WORKSPACE=/root/workspace
DIR=/usr/local
ALE_LOG_FILE=/tmp/alertmanager.log

echo "Get command parameter" > $ALE_LOG_FILE
mkdir -p $ENV_WORKSPACE
yum install curl -y >> $ALE_LOG_FILE

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

install_alertmanager() {
  alertver=alertmanager-0.21.0
  alerttar=$alertver.linux-amd64.tar.gz
  alertdir=$DIR/alertmanager
  alerthash=9ccd863937436fd6bfe650e22521a7f2e6a727540988eef515dde208f9aef232
  [ -f $ENV_WORKSPACE/$alerttar ] && altersum=`sha256sum $ENV_WORKSPACE/$alerttar`
  if [ "x$altersum" == "x$alerthash" ]; then
    echo "$alerttar is already downloaded at $ENV_WORKSPACE" >> $ALE_LOG_FILE
  else
    echo "Download $alerttar to $ENV_WORKSPACE" >> $ALE_LOG_FILE
    reliable_download http://$DOWNLOAD_IMG_HOST/$alerttar $ENV_WORKSPACE/$alerttar
    altersum=`sha256sum $ENV_WORKSPACE/$alerttar`
  fi
  echo "Install alertmanager..." >> $ALE_LOG_FILE
  cd $ENV_WORKSPACE
  ls >> $ALE_LOG_FILE
  tar xvvf $alerttar 
  ls >> $ALE_LOG_FILE
  mkdir -p $alertdir
  cp -r $alertver.linux-amd64/* $alertdir/
  mv /alertmanager.yml $alertdir/
  mv /alert-template.tmp1 $alertdir/
}

install_alertmanager
/usr/local/alertmanager/alertmanager --config.file=/usr/local/alertmanager/alertmanager.yml --storage.path=/usr/local/alertmanager/data --cluster.advertise-address=0.0.0.0:9093 >> $ALE_LOG_FILE 2>&1


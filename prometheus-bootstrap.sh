#!/bin/bash

echo "etcd host: $ENTROPY_ETCD_HOSTS, prometheus host: $ENTROPY_PROMETHEUS_HOST"
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/prometheus.npool.top "{\"host\":\"$ENTROPY_PROMETHEUS_HOST\"}"


ENV_WORKSPACE=/root/workspace
DIR=/usr/local
PRO_LOG_FILE=/tmp/prometheus.log
DEVOPS_LOG_FILE=/tmp/fbc-devops.log
IP=`hostname -I`
prover=prometheus-2.20.1
protar=$prover.linux-amd64.tar.gz
prodir=$DIR/prometheus
FBC_DEVOPS=fbc-devops-peer
FBC_LICENSE=fbc-license

echo "Get command parameter" > $PRO_LOG_FILE
echo "Get command parameter" > $DEVOPS_LOG_FILE
mkdir -p $ENV_WORKSPACE
yum install curl -y >> $PRO_LOG_FILE

function error() {
  echo "  <E> -> $1 ~"
  exit 1
}

function warn() {
  echo "  <W> -> $1 ~"
}

function info() {
  echo "  <I> -> $1 ~"
}

function reliable_download() {
  while true; do
    info "Try to download $1 at $2" >> $PRO_LOG_FILE
    curl -L $1 -o $2
    [ ! $? -eq 0 ] && warn "Cannot download $1" && continue
    break
  done
}

function file_sha256sum() {
  sha256sum $1 | awk -F " " '{print $1}'
}

function install_prometheus_service() {
  prohash=8fb248b579b8b9a88dd9b1686f7f68db7071960a45b28619145d3a4037375dcb
  [ -f $ENV_WORKSPACE/$protar ] && sum=`sha256sum $ENV_WORKSPACE/$protar`
  if [ "x$sum" == "x$prohash" ]; then
    info "$protar is already downloaded at $ENV_WORKSPACE" >> $PRO_LOG_FILE
  else
    info "Download $protar to $ENV_WORKSPACE" >> $PRO_LOG_FILE
    ALL_PROXY= reliable_download  http://$DOWNLOAD_IMG_HOST/$protar $ENV_WORKSPACE/$protar
    sum=`sha256sum $ENV_WORKSPACE/$protar`
  fi
  info "Untar prometheus..." >> $PRO_LOG_FILE
  cd $ENV_WORKSPACE
  tar xf $protar >> $PRO_LOG_FILE
  mkdir -p $prodir
  cp -r $prover.linux-amd64/* $prodir/
  mkdir -p $prodir/rules
  mv /alert-rules.yml $prodir/rules/
  info "done..." >> $PRO_LOG_FILE
}

function install_golang() {
  rm -rf /usr/local/go
  wget https://studygolang.com/dl/golang/go1.16.5.linux-amd64.tar.gz
  tar -xzf go1.16.5.linux-amd64.tar.gz -C /usr/local/
  export PATH=$PATH:/usr/local/go/bin
  rm -rf go1.16.5.linux-amd64.tar.gz
}

function install_devops_peer() {
  rm -rf $ENV_WORKSPACE/$FBC_DEVOPS
  rm -rf $ENV_WORKSPACE/$FBC_LICENSE

  echo $SOCKS > ~/.git-credentials
  echo $GITINFO >> ~/.git-credentials
  info "clone... $FBC_LICENSE" >> $DEVOPS_LOG_FILE
  git config --global credential.helper store
  git clone https://github.com/NpoolDevOps/$FBC_LICENSE.git $ENV_WORKSPACE/$FBC_LICENSE
  if [ ! $? -eq 0 ]; then
    error "CANNOT clone $FBC_LICENSE" >> $DEVOPS_LOG_FILE
  fi

  info "clone... $FBC_DEVOPS" >> $DEVOPS_LOG_FILE
  git clone https://github.com/NpoolDevOps/$FBC_DEVOPS.git $ENV_WORKSPACE/$FBC_DEVOPS
  if [ ! $? -eq 0 ]; then
    error "CANNOT clone $FBC_DEVOPS" >> $DEVOPS_LOG_FILE
  else
    cd $ENV_WORKSPACE/$FBC_DEVOPS
    info "go build..." >> $DEVOPS_LOG_FILE
    export GOPROXY=https://goproxy.cn
    go build
    info "go build done" >> $DEVOPS_LOG_FILE
  fi
}

function install_idc_devops() {
  IDC=$IDC
  info "IDC ==  $IDC" >> $DEVOPS_LOG_FILE
  if [ "x$IDC" == "xtrue" ]; then
    info "install devops peer" >> $DEVOPS_LOG_FILE
    install_devops_peer
    cd $ENV_WORKSPACE/$FBC_DEVOPS
    info "Run devops peer..." >> $DEVOPS_LOG_FILE
    ./$FBC_DEVOPS --main-role=gateway --network-type=filecoin --username=$USERNAME --password=$PASSWORD --test-mode=true --snmp-monitor=true --snmp-user=$SNMP_USER --snmp-pass=$SNMP_PASS --snmp-target=$SNMP_TARGET --snmp-community=$SNMP_COMMUNITY --location-label=$LABLE --mon-address=$IP >> $DEVOPS_LOG_FILE 2>&1 &

    sleep 30

    info "Post prometheus-peer.npool.top..." >> $DEVOPS_LOG_FILE
    ALL_PROXY= curl https://$ETCD_REGISTER/api/v0/service/register -X POST -d "{\"UserName\":\"$USERNAME\", \"Password\":\"$PASSWORD\", \"DomainName\":\"prometheus-peer.npool.top\", \"IP\":\"$PUBLIC_IP\", \"Port\":\"$PUBLIC_PORT\"}" --header "Content-Type: application/json" -H "Host:etcd-register.npool.top" --insecure
    echo curl https://$ETCD_REGISTER/api/v0/service/register -X POST -d "{\"UserName\":\"$USERNAME\", \"Password\":\"$PASSWORD\", \"DomainName\":\"prometheus-peer.npool.top\", \"IP\":\"$PUBLIC_IP\", \"Port\":\"$PUBLIC_PORT\"}" --header "Content-Type: application/json" -H "Host:etcd-register.npool.top" --insecure >> $DEVOPS_LOG_FILE
  fi
}

function install_federate_prometheus() {
  IPS=/ip.list
  PROMETHEUS_CONFIG=$prodir/prometheus.yml
  if [ "$IDC" == "" ]; then
    mv /prometheus.yml $prodir/
      while true; do
        etcdctl --endpoints=172.172.0.2:2379 get root/prometheus-peer.npool.top | awk 'NR==2' | tr "{" "\n" |sed -nr 's/\"IP\":\"(.*)\",\"Port\":\"(.*)\".*/\1:\2/gp' > $IPS
        while read line; do
          grep -w "$line" $PROMETHEUS_CONFIG > /dev/null 2>&1
          [ ! $? -eq 0 ] && echo "        - $line" >>$PROMETHEUS_CONFIG
        done < $IPS
        sleep 10
      done
  fi
} 

install_golang
install_prometheus_service
install_idc_devops
install_federate_prometheus

info "Run prometheus..." >> $PRO_LOG_FILE
$prodir/prometheus --config.file=$prodir/prometheus.yml --storage.tsdb.path=$prodir/data --web.enable-lifecycle >> $PRO_LOG_FILE 2>&1


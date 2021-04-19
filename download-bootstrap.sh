#!/bin/bash
TARS_CFG=/nginx/tars.lst
CURDIR=/nginx
LOG_FILE=/tmp/download.log

echo "etcd host: $ENTROPY_ETCD_HOSTS, download host: $ENTROPY_DOWNLOAD_HOST"
etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/download.npool.top "{\"host\":\"$ENTROPY_DOWNLOAD_HOST\"}"

function info() {
  echo "  <I> $1 ~"
}

function warn() {
  echo "  <W> $1 ~"
}

function error() {
  echo "  <E> $1 ~"
  exit 1
}

function reliable_download() {
  while true; do
    info "Try to download $1 -> $2"
    curl -L $1 -o $2
    [ $? -eq 0 ] && break
  done
}

function download_tars() {
  mkdir -p /nginx/download/
  while read line; do
    echo $line | grep "^#" > /dev/null 2>&1
    [ $? -eq 0 ] && continue
    url=`echo $line | awk -F " " '{print $1}'`
    directory=`echo $line | awk -F " " '{print $2}'`
    digest=`echo $line | awk -F " " '{print $3}'`
    tarname=`basename $url`
    tarpath=$CURDIR/$directory/$tarname
    if [ -f $tarpath ]; then
      ddigest=`sha256sum $tarpath | awk -F " " '{print $1}'`
      [ "x$ddigest" == "x$digest" ] && info "$tarname is already downloaded" && continue
      info "$tarname [$ddigest != $digest]"
    fi
    reliable_download $url $tarpath
    ddigest=`sha256sum $tarpath | awk -F " " '{print $1}'`
    [ "x$ddigest" != "x$digest" ] && error "Mismatch checksum of $tarname from $url"
  done < $TARS_CFG
}
download_tars

rm /etc/nginx/conf.d/default.conf -rf
/docker-entrypoint.sh nginx -g 'daemon off;' >> $LOG_FILE 2>&1

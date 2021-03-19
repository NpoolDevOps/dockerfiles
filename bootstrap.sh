#!/bin/bash

LOG_FILE=/tmp/bootstrap.log

echo "Get command parameter" > $LOG_FILE

while [ ! $# -eq 0 ]; do
  case "$1" in
    --repo) GITREPO="$2"; shift 2 ;;
    --rev)  REVISION="$2"; shift 2 ;;
    --run)  RUNSCRIPT="$2"; shift 2 ;;
    --role) ROLE="$2"; shift 2 ;;
  esac
done

function usage() {
  echo "usage $0"
  echo "  --repo repo                 git repo to be clone here"
  echo "  --rev revision              git repo revision to be checkout"
  echo "  --run run                   script used to initialize this repo in the git repo"
  echo "  --role role                 role of this docker"
  exit 1
}

echo "Check parameters" >> $LOG_FILE

[ "x$RUNSCRIPT" == "x" ] && usage $0
[ "x$ROLE" == "x" ] && usage $0

echo "Install git ..." >> $LOG_FILE

if [ ! -f .bootstrapped ]; then
  cat /etc/issue | grep "Debian"
  if [ $? -eq 0 ]; then
    sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
    sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list
    apt-get clean
    apt-get update >> $LOG_FILE
    apt-get install git -y >> $LOG_FILE
    apt-get install vim -y >> $LOG_FILE
    apt-get install wget -y >> $LOG_FILE
  else
    yum install git -y
    yum install vim -y
    yum install wget -y
  fi
  echo "Install etcdctl ..." >> $LOG_FILE
  wget http://106.14.125.55:8888/etcd-v3.4.14-linux-amd64.tar.gz -O /tmp/etcd-v3.4.14-linux-amd64.tar.gz
  tar xf /tmp/etcd-v3.4.14-linux-amd64.tar.gz -C /tmp
  mv /tmp/etcd-v3.4.14-linux-amd64/etcdctl /usr/bin
fi

if [ -f .bootstrapped ]; then
  oldrev=`cat .bootstrapped`
fi

echo "Clone $GITREPO/$REVISION ..." >> $LOG_FILE
if [ "x$oldrev" != "x$REVISION" ]; then
  if [ "x$GITREPO" != "x" ]; then
    echo "Clone $GITREPO ..." >> $LOG_FILE
    if [ ! -d my-repo ]; then
      git clone $GITREPO my-repo
      cd my-repo
      git checkout $REVISION
      cd -
    else
      cd my-repo
      git checkout master
      git pull
      git checkout $REVISION
      cd -
    fi
    [ ! $? -eq 0 ] && echo "cannot clone $GITREPO" >> $LOG_FILE && exit 2
  fi
fi

[ ! -f "$RUNSCRIPT" ] && echo "$RUNSCRIPT is not exist in" >> $LOG_FILE && exit 3

echo "Run $RUNSCRIPT ..." >> $LOG_FILE
chmod a+x $RUNSCRIPT
$RUNSCRIPT --role $ROLE >> $LOG_FILE 2>&1
[ ! $? -eq 0 ] && echo "fail to run $RUNSCRIPT" >> $LOG_FILE && exit 4

echo $REVISION > .bootstrapped

while true; do sleep 1000; done

exit 0

#!/bin/bash

LOG_FILE=/tmp/bootstrap.log

echo "Get command parameter" > $LOG_FILE

while [ ! $# -eq 0 ]; do
  case "$1" in
    --repo) GITREPO="$2"; shift 2 ;;
    --run)  RUNSCRIPT="$2"; shift 2 ;;
    --role) ROLE="$2"; shift 2 ;;
  esac
done

function usage() {
  echo "usage $0"
  echo "  --repo repo                 git repo to be clone here"
  echo "  --run run                   script used to initialize this repo in the git repo"
  echo "  --role role                 role of this docker"
  exit 1
}

echo "Check parameters" >> $LOG_FILE

[ "x$RUNSCRIPT" == "x" ] && usage $0
[ "x$ROLE" == "x" ] && usage $0

echo "Install git ..." >> $LOG_FILE
yum install git -y

echo "Install etcdctl ..." >> $LOG_FILE
wget https://github.com/coreos/etcd/releases/download/v3.4.14/etcd-v3.4.14-linux-amd64.tar.gz
tar xf etcd-v3.4.14-linux-amd64.tar.gz -C /tmp
mv /tmp/etcd-v3.4.14-linux-amd64/etcdctl /usr/bin

if [ "x$GITREPO" != "x" ]; then
  echo "Clone $GITREPO ..." >> $LOG_FILE
  git clone $GITREPO my-repo
  [ ! $? -eq 0 ] && echo "cannot clone $GITREPO" && exit 1
fi

[ ! -f "$RUNSCRIPT" ] && echo "$RUNSCRIPT is not exist in" >> $LOG_FILE && exit 1

chmod a+x $RUNSCRIPT
$RUNSCRIPT --role $ROLE >> $LOG_FILE
[ ! $? -eq 0 ] && echo "fail to run $RUNSCRIPT" && exit 1

while true; do sleep 1000; done

exit 0

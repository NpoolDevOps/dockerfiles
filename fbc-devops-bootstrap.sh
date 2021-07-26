#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/devops.npool.top "{\"host\":\"$ENTROPY_DEVOPS_HOST:$PORT\"}"
echo $PORT
sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/fbc-devops-service.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build

cat > /etc/logrotate.d/devops << EOF
/tmp/fbc-devops.log {
        size 1G
        rotate 1
        missingok
        notifempty
        copytruncate
        create root root
}
EOF
echo "0,30 * * * * /usr/sbin/logrotate /etc/logrotate.d/devops > /dev/null 2>&1" > /home/crontab.txt
systemctl start crond

./fbc-devops-service >> /tmp/fbc-devops.log 2>&1

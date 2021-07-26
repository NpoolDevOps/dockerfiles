#!/bin/bash

etcdctl --endpoints=$ENTROPY_ETCD_HOSTS put root/license.npool.top "{\"host\":\"$ENTROPY_LICENSE_HOST:$PORT\"}"

echo $PORT
sed -i s/\"port\".*/\"port\":\ $PORT/g  /my-repo/fbc-license-service.conf

cd /my-repo/
export GOPROXY=https://goproxy.cn
go build

cat > /etc/logrotate.d/license << EOF
/tmp/fbc-license.log {
        size 1G
        rotate 1
        missingok
        notifempty
        copytruncate
        create root root
}
EOF
echo "0,30 * * * * /usr/sbin/logrotate /etc/logrotate.d/license > /dev/null 2>&1" > /home/crontab.txt
systemctl start crond

./fbc-license-service >> /tmp/fbc-license.log 2>&1

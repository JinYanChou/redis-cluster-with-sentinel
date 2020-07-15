#!/bin/sh

mkdir -p /etc/redis
cp /tmp/sentinel.conf /etc/redis/sentinel.conf

REDIS_MASTER_IP=''
REDIS_SLAVE_IP=''
until [[ ! -z "$REDIS_MASTER_IP" ]] && [[ ! -z "$REDIS_SLAVE_IP" ]]
do
  REDIS_MASTER_IP=`echo $(getent hosts $REDIS_MASTER | cut -d' ' -f1)`
  REDIS_SLAVE_IP=`echo $(getent hosts $REDIS_SLAVE | cut -d' ' -f1)`
  echo "waiting for service";
  echo "master: ${REDIS_MASTER}";
  echo "slave: ${REDIS_SLAVE}";
  sleep 2;
done

MASTER_ROLE=`redis-cli -h $REDIS_MASTER info | grep ^role`
SLAVE_ROLE=`redis-cli -h $REDIS_SLAVE info | grep ^role`
MASTER_ROLE=`echo ${MASTER_ROLE} | xargs`
SLAVE_ROLE=`echo ${SLAVE_ROLE} | xargs`
if [ "${SLAVE_ROLE}" == "role:master" ]; then
  echo "change master to slave";
  REDIS_MASTER_IP="${REDIS_SLAVE_IP}"
fi
echo "REDIS_MASTER_IP: ${REDIS_MASTER_IP}";

sed -i "s/\$INSTANCE/$INSTANCE/g" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_PORT/$SENTINEL_PORT/g" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_QUORUM/$SENTINEL_QUORUM/g" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_DOWN_AFTER/$SENTINEL_DOWN_AFTER/g" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_FAILOVER/$SENTINEL_FAILOVER/g" /etc/redis/sentinel.conf
sed -i "s/\$REDIS_MASTER/$REDIS_MASTER_IP/g" /etc/redis/sentinel.conf

exec docker-entrypoint.sh redis-server /etc/redis/sentinel.conf --sentinel

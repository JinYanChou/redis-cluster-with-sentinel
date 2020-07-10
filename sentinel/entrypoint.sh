#!/bin/sh

if [ ! -f "/etc/redis/sentinel.conf" ]; then

  mkdir -p /etc/redis
  cp /tmp/sentinel.conf /etc/redis/sentinel.conf
  REDIS_MASTER_IP=''

  until [[ -n "$REDIS_MASTER_IP" ]]
  do
    REDIS_MASTER_IP=`echo $(getent hosts redis-master | cut -d' ' -f1)`
    echo "waiting for redis-master";
    sleep 2;
  done

  sed -i "s/\$SENTINEL_PORT/$SENTINEL_PORT/g" /etc/redis/sentinel.conf
  sed -i "s/\$SENTINEL_QUORUM/$SENTINEL_QUORUM/g" /etc/redis/sentinel.conf
  sed -i "s/\$SENTINEL_DOWN_AFTER/$SENTINEL_DOWN_AFTER/g" /etc/redis/sentinel.conf
  sed -i "s/\$SENTINEL_FAILOVER/$SENTINEL_FAILOVER/g" /etc/redis/sentinel.conf
  sed -i "s/\$REDIS_MASTER/$REDIS_MASTER_IP/g" /etc/redis/sentinel.conf

fi

exec docker-entrypoint.sh redis-server /etc/redis/sentinel.conf --sentinel

FROM redis:6.0.1-alpine

ENV SENTINEL_QUORUM=2 \
    SENTINEL_DOWN_AFTER=5000 \
    SENTINEL_FAILOVER=10000 \
    SENTINEL_PORT=26000 \
    REDIS_MASTER="redis-master"

COPY entrypoint.sh /usr/local/bin/
COPY sentinel.conf /tmp/sentinel.conf

RUN chmod 666 /tmp/sentinel.conf \
    && chown redis:root /tmp/sentinel.conf \
    && chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /etc/redis

ENTRYPOINT ["entrypoint.sh"]

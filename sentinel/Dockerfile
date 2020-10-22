# docker build . -t 10.95.28.159:8083/baseimage/redis:6.0-sentinel-1.0
FROM bitnami/redis:6.0

ENV ALLOW_EMPTY_PASSWORD=yes \
    SENTINEL_QUORUM=1 \
    SENTINEL_DOWN_AFTER=1000 \
    SENTINEL_FAILOVER=10000 \
    SENTINEL_PORT=26379 \
    REDIS_MASTER="redis-master" \
    REDIS_SLAVE="redis-slave" \
    INSTANCE="mymaster"

COPY --chown=1001:0 entrypoint.sh /usr/local/bin/
COPY --chown=1001:0 sentinel.conf /etc/redis/sentinel.conf

USER root
RUN chmod 666 /etc/redis/sentinel.conf && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    chown -R 1001:0 /etc/redis && \
    chmod 777 /etc/redis
USER 1001

WORKDIR /etc/redis

ENTRYPOINT ["entrypoint.sh"]

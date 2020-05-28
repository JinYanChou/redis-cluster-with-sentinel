FROM redis:6.0.1-alpine

ENV SENTINEL_QUORUM=2 \
    SENTINEL_DOWN_AFTER=5000 \
    SENTINEL_FAILOVER=10000 \
    SENTINEL_PORT=26000

COPY sentinel.conf /etc/redis/sentinel.conf
COPY entrypoint.sh /usr/local/bin/

RUN chown redis:redis /etc/redis/sentinel.conf \
    && chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
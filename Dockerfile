FROM goacme/lego:v4.19 AS LEGO

FROM alpine:3
RUN apk update \
    && apk add --no-cache tini bash

COPY ./root /

RUN chmod +x /usr/bin/lego-certbot /entrypoint.sh \
    && crontab /etc/crontab \
    && touch /var/log/cron

COPY --from=LEGO /lego /usr/bin/lego

VOLUME [ "/data" ]

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]
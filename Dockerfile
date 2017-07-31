FROM alpine:edge

RUN apk update \
   && apk add --no-cache \
           curl \
           make \
           gcc \
           musl-dev

COPY files/* /app/

RUN adduser -S -D -u 1000 -h /app fiche \
   && cd /app \
   && make \
   && chmod +x entrypoint.sh \
   && mkdir -p /data \
   && chown -R fiche /app /data

USER fiche

VOLUME /app /data

WORKDIR /app

EXPOSE 9999

CMD ["/app/entrypoint.sh"]


FROM httpd:2.4-alpine

RUN apk update \
   && apk add --no-cache \
           curl \
           git \
           make \
           gcc \
           musl-dev

COPY files/entrypoint.sh /usr/bin/entrypoint

RUN chmod +x /usr/bin/entrypoint \
   && mkdir -p /termbin/basedir /termbin/confs

RUN git clone https://github.com/solusipse/fiche.git /termbin/code

RUN cd /termbin/code \
   && make \
   && make install

VOLUME /termbin/basedir /termbin/confs

EXPOSE 9999

CMD ['/usr/bin/entrypoint.sh']


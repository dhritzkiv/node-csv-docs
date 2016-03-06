FROM jumanjiman/caddy
MAINTAINER David Worms <david@adaltas.com>

USER root
RUN apk update && apk add nodejs && rm -rf /var/cache/apk/*
#RUN mkdir /etc/caddy/out && chown -R caddy /etc/caddy
#RUN mkdir -p /etc/caddy && chown -R caddy /etc/caddy
RUN mkdir -p /www && chown caddy /www
WORKDIR /www
USER caddy

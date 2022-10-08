FROM nginx:alpine

RUN apk update && apk upgrade && apk add --no-cache bash

RUN set -x ; \
    addgroup -g 82 -S www-data ; \
    adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

COPY ./conf/nginx.conf /etc/nginx/

EXPOSE 80

#!/bin/bash

echo "upstream $APP_FOLDER { server $UPSTREAM_CONTAINER:8000; }"\
"server {"\
    "server_name $APPLICATION_ADDRESS;"\
    "listen 80;"\
    "location / {"\
        "proxy_pass http://$APP_FOLDER;"\
        "proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;"\
        "proxy_set_header Host \$host;"\
        "proxy_redirect off;"\
    "}"\
    "error_log /var/log/nginx/$APP_FOLDER.error.log info;"\
    "access_log /var/log/nginx/$APP_FOLDER.access.log;"\
    "location /static/ {"\
        "alias $APP_DIR/$APP_FOLDER/$STATIC_FILES_FOLDER/;"\
    "}"\
    "location /media/ {"\
        "alias $APP_DIR/$APP_FOLDER/$MEDIA_FILES_FOLDER/;"\
    "}"\
"}" > /etc/nginx/conf.d/${APP_FOLDER}.conf

exec "$@"

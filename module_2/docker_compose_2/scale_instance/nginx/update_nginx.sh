#!/bin/bash

# Отримання IP адрес екземплярів сервісу app
# shellcheck disable=SC2046
APP_IPS=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q --filter "name=app"))

# Формування рядка серверів для конфігурації
SERVERS=""
for IP in $APP_IPS; do
    SERVERS+="server $IP:80;\n"
done

# Заміна плейсхолдера у шаблоні конфігурації Nginx
sed "s|{{app_servers}}|$SERVERS|" ./nginx/default.conf.template > ./nginx/default.conf

# Перезапуск Nginx для нової конфігурації
docker-compose restart nginx
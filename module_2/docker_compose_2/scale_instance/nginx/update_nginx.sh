#!/bin/bash

# Отримуємо IP адреси екземплярів сервісу app
# shellcheck disable=SC2046
APP_IPS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q --filter "name=app"))

# Формуємо рядок серверів для конфігурації
SERVERS=""
for IP in $APP_IPS; do
    SERVERS+="server $IP:80;"
done

# Створюємо файл, якщо він не існує
touch ./nginx/default.conf

# Замінюємо плейсхолдер у шаблоні конфігурації Nginx і створюємо файл default.conf
sed "s|{{app_servers}}|$SERVERS|" ./nginx/default.conf.template > ./nginx/default.conf.tmp && mv ./nginx/default.conf.tmp ./nginx/default.conf

# Перезапускаємо Nginx для застосування нової конфігурації
docker-compose restart nginx

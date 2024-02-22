# Используйте официальный образ Nginx
FROM nginx:alpine

# Удалите стандартную страницу Nginx
RUN rm -rf /usr/share/nginx/html/*

# Скопируйте статические файлы сайта в контейнер
COPY . /usr/share/nginx/html

# Опубликуйте порт 80
EXPOSE 80

# Запустите Nginx и убедитесь, что он не работает в фоновом режиме
CMD ["nginx", "-g", "daemon off;"]

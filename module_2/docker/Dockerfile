# Використовуємо базовий образ, наприклад, Ubuntu
FROM ubuntu:latest

# Оновлюємо пакети та встановлюємо Nginx
RUN apt-get update && apt-get install nginx -y

# Вказуємо користувача, з яким буде запущений контейнер (root)
USER root

# Змінюємо власника директорії /var/run/nginx та /var/log/nginx (або інших директорій, які вам потрібні)
RUN chown -R www-data:www-data /var/run/nginx /var/log/nginx

# Команда, яка виконується при запуску контейнера (можна вказати свою)
CMD ["nginx", "-g", "daemon off;"]
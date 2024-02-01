# Використовуємо базовий образ, наприклад, Ubuntu
FROM ubuntu:latest

# Додаємо декілька команд для налаштування користувача Test
# Додавання користувача
RUN useradd -ms /bin/bash Test

# Змінюємо власника деяких директорій на користувача Test (опціонально)
RUN chown -R Test /var/run/nginx /var/log/nginx

# Встановлюємо Nginx (під користувачем "Test")
USER Test
RUN apt-get update && apt-get install nginx -y

# Команда, яка виконується при запуску контейнера (можна вказати свою)
CMD ["nginx", "-g", "daemon off;"]
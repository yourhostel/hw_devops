# Використовуємо базовий образ Ubuntu
FROM ubuntu:latest AS builder

# Встановлюємо необхідні пакети
RUN apt-get update && \
    apt-get install -y python3 nginx

# Вказуємо порт, який буде відкритий
EXPOSE 8080

# Вказуємо команду, яка виконується при запуску контейнера
CMD ["nginx", "-g", "daemon off;"]

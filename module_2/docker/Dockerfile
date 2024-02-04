# Використовуємо базовий образ Ubuntu
FROM ubuntu:20.04

# Вимикаємо запити під час установки пакетів
ARG DEBIAN_FRONTEND=noninteractive

# Встановлюємо необхідні пакети
RUN apt-get update && \
    apt-get install -y python3 nginx nano tree mc && \
    rm -rf /var/lib/apt/lists/* # очищення кешу APT

# EXPOSE вказує, що контейнер слухає порт 80
EXPOSE 80

# Запускаємо nginx на передньому плані
CMD ["nginx", "-g", "daemon off;"]


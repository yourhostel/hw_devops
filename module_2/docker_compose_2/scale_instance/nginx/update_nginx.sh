#!/bin/bash

# Генеруємо новий конфігураційний файл Nginx
./nginx/generate_conf.py

# Перезапускаємо Nginx для застосування нової конфігурації
docker compose restart nginx

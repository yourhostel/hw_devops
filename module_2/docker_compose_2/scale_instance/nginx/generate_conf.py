#!/usr/bin/env python3
import os
import re
import subprocess

# Отримуємо список IP-адрес запущених контейнерів app
result = subprocess.run(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', *subprocess.check_output(['docker', 'ps', '-q', '--filter', 'name=app']).splitlines()], capture_output=True, text=True)
ip_addresses = result.stdout.strip().split('\n')

# Формуємо рядок серверів для Nginx
servers = ';\n'.join([f"server {ip}:80" for ip in ip_addresses]) + ';'

script_dir = os.path.dirname(os.path.abspath(__file__))
template_path = os.path.join(script_dir, 'default.conf.template')
config_path = os.path.join(script_dir, 'default.conf') # Використовуємо абсолютний шлях для default.conf

# Читаємо шаблон конфігурації
with open(template_path, 'r') as file:
    template = file.read()

# Замінюємо плейсхолдер на рядок серверів
config = re.sub(r'{{app_servers}}', servers, template)

# Записуємо кінцевий конфіг у default.conf, використовуючи абсолютний шлях
with open(config_path, 'w') as file:
    file.write(config)

#!/usr/bin/env python3
import re
import subprocess

# Отримуємо список IP-адрес запущених контейнерів app
result = subprocess.run(['docker', 'inspect', '-f', '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}', *subprocess.check_output(['docker', 'ps', '-q', '--filter', 'name=app']).splitlines()], capture_output=True, text=True)
ip_addresses = result.stdout.strip().split('\n')

# Формуємо рядок серверів для Nginx
servers = ';\n'.join([f"server {ip}:80" for ip in ip_addresses]) + ';'

# Читаємо шаблон конфігурації
with open('default.conf.template', 'r') as file:
    template = file.read()

# Замінюємо плейсхолдер на рядок серверів
config = re.sub(r'{{app_servers}}', servers, template)

# Записуємо кінцевий конфіг у default.conf
with open('default.conf', 'w') as file:
    file.write(config)

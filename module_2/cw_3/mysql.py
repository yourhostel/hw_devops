import random
import string
import subprocess


def install_mysql():
    # Проверяем, установлен ли MySQL
    if not subprocess.run(["dpkg-query", "-l", "mysql-server"], capture_output=True, text=True).stdout:
        # Устанавливаем MySQL, если он не установлен
        subprocess.run(["sudo", "apt", "install", "-y", "mysql-server"])
        print("MySQL Server установлен.")

        # После установки пытаемся запустить MySQL
        subprocess.run(["sudo", "systemctl", "start", "mysql"])
        print("MySQL сервис запущен.")
    else:
        print("MySQL Server уже установлен.")

        # Проверяем, запущен ли MySQL
        status = subprocess.run(["systemctl", "is-active", "mysql"], capture_output=True, text=True).stdout.strip()
        if status != "active":
            subprocess.run(["sudo", "systemctl", "start", "mysql"])
            print("MySQL сервис был неактивен и теперь запущен.")
        else:
            print("MySQL сервис уже запущен.")


install_mysql()

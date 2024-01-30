import random
import string
import subprocess


def generate_password(length=12):
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for i in range(length))


password = generate_password()


def install_mysql():
    if not subprocess.run(["dpkg-query", "l", "mysql-server"], capture_output=True, text=True).stdout:
        subprocess.run(["sudo", "apt", "install", "-y", "mysql-server"])
    else:
        print("MySQL Server уже установлен.")

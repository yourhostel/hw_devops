import subprocess
import sys
import random
import string
import getpass


def install_mysql():
    # Перевірка, чи встановлено MySQL
    if not subprocess.run(["dpkg-query", "-l", "mysql-server"], capture_output=True, text=True).stdout:
        # Встановлення MySQL, якщо він не встановлений
        subprocess.run(["sudo", "apt", "install", "-y", "mysql-server"])
        print("MySQL Server встановлено.")

        # Після встановлення намагаємося запустити MySQL
        subprocess.run(["sudo", "systemctl", "start", "mysql"])
        print("Сервіс MySQL запущено.")
    else:
        print("MySQL Server вже встановлено.")

        # Перевірка, чи запущено MySQL
        status = subprocess.run(["systemctl", "is-active", "mysql"], capture_output=True, text=True).stdout.strip()
        if status != "active":
            subprocess.run(["sudo", "systemctl", "start", "mysql"])
            print("Сервіс MySQL був неактивний і тепер запущено.")
        else:
            print("Сервіс MySQL вже запущено.")


def install_mysql_connector():
    # Перевірка та встановлення MySQL Connector/Python, якщо він не встановлений
    try:
        import mysql.connector
        print("MySQL Connector/Python вже встановлено.")
    except ImportError:
        print("Встановлення MySQL Connector/Python.")
        subprocess.run([sys.executable, "-m", "pip", "install", "mysql-connector-python"])
        print("MySQL Connector/Python успішно встановлено.")


def generate_password(length=12):
    # Генерація випадкового пароля
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for i in range(length))


def create_mysql_user(user, password, root_password):
    # Створення користувача MySQL
    try:
        import mysql.connector
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password=root_password
        )
        cursor = connection.cursor()
        cursor.execute(f"CREATE USER '{user}'@'localhost' IDENTIFIED BY '{password}';")
        cursor.execute(f"GRANT ALL PRIVILEGES ON *.* TO '{user}'@'localhost' WITH GRANT OPTION;")
        connection.commit()
        print(f"Користувач '{user}' успішно створений з паролем: {password}")
    except mysql.connector.Error as err:
        print("Помилка MySQL:", err)
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()


# Встановлення MySQL Server, якщо він не встановлений
install_mysql()

# Встановлення MySQL Connector/Python, якщо він не встановлений
install_mysql_connector()

# Запит пароля для користувача root
root_password = getpass.getpass("Будь ласка, введіть пароль для користувача root MySQL: ")

# Генерація пароля
password = generate_password()

# Створення користувача MySQL
user = "tysser"
create_mysql_user(user, password, root_password)

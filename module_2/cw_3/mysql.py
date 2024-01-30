import subprocess
import sys
import random
import string


def install_mysql_connector():
    try:
        import mysql.connector
        print("MySQL Connector/Python вже встановлено.")
    except ImportError:
        print("Встановлення MySQL Connector/Python.")
        subprocess.run([sys.executable, "-m", "pip", "install", "mysql-connector-python"])
        print("MySQL Connector/Python успішно встановлено.")


def generate_password(length=12):
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for i in range(length))


def create_mysql_user(user, password):
    try:
        import mysql.connector
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='your_root_password'  # Замініть на реальний пароль root користувача MySQL
        )
        cursor = connection.cursor()
        cursor.execute(f"CREATE USER '{user}'@'localhost' IDENTIFIED BY '{password}';")
        cursor.execute(f"GRANT ALL PRIVILEGES ON *.* TO '{user}'@'localhost' WITH GRANT OPTION;")
        connection.commit()
        print(f"Користувач '{user}' успішно створений з паролем: {password}")
    except mysql.connector.Error as err:
        print("Помилка MySQL:", err)
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()


# Встановлення MySQL Connector/Python, якщо він не встановлений
install_mysql_connector()

# Генерація пароля
password = generate_password()

# Створення користувача MySQL
user = "tysser"
create_mysql_user(user, password)

import subprocess
import sys
import random
import string
import getpass


def install_mysql_connector():
    try:
        import mysql_setup.connector
        print("MySQL Connector/Python вже встановлено.")
    except ImportError:
        print("Встановлення MySQL Connector/Python.")
        subprocess.run([sys.executable, "-m", "pip", "install", "mysql-connector-python"])
        print("MySQL Connector/Python успішно встановлено.")


def generate_password(length=12):
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for i in range(length))


def create_mysql_user(user, password, root_password):
    try:
        import mysql_setup.connector
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
        if connection.is_connected():
            cursor.close()
            connection.close()


# Встановлення MySQL Connector/Python, якщо він не встановлений
install_mysql_connector()

# Просимо користувача ввести пароль для root
root_password = getpass.getpass("Будь ласка, введіть пароль для користувача root MySQL: ")

# Генерація пароля
password = generate_password()

# Створення користувача MySQL
user = "tysser"
create_mysql_user(user, password, root_password)

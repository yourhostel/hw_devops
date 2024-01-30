import subprocess
import sys
import random
import string


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
    # Створення користувача MySQL, якщо його не існує
    try:
        import mysql.connector
        connection = mysql.connector.connect(
            host='localhost'
        )
        cursor = connection.cursor()
        cursor.execute(f"CREATE USER IF NOT EXISTS '{user}'@'localhost' IDENTIFIED BY '{password}';")
        cursor.execute(f"GRANT ALL PRIVILEGES ON *.* TO '{user}'@'localhost' WITH GRANT OPTION;")
        connection.commit()
        print(f"Користувач '{user}' успішно створений або вже існує з паролем: {password}")
    except mysql.connector.Error as err:
        print("Помилка MySQL:", err)
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()


def create_database_and_table(user, root_password):
    try:
        import mysql.connector
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password=root_password
        )
        cursor = connection.cursor()

        # Створення бази даних, якщо вона не існує
        cursor.execute("CREATE DATABASE IF NOT EXISTS mydatabase;")
        print("База даних 'mydatabase' створена або вже існує.")

        # Вибір бази даних
        cursor.execute("USE mydatabase;")

        # Створення таблиці "users", якщо вона не існує
        cursor.execute("CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, "
                       "username VARCHAR(255), role VARCHAR(255));")
        print("Таблиця 'users' створена або вже існує.")

        # Додавання запису "tysser" з роллю "super"
        cursor.execute("INSERT INTO users (username, role) VALUES (%s, %s);", ("tysser", "super"))
        connection.commit()
        print("Запис 'tysser' з роллю 'super' доданий до таблиці 'users'.")

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

# Генерація пароля для користувача "tysser"
password = generate_password()

# Створення користувача MySQL
user = "tysser"
create_mysql_user(user, password, root_password)

# Створення бази даних та таблиці "users"
create_database_and_table(user, root_password)

# Виведення імені користувача та його пароля
print(f"Ім'я користувача: {user}")
print(f"Пароль користувача: {password}")

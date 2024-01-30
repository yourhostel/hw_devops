import subprocess
import sys
import random
import string
import getpass

MYSQL_ROOT_PASSWORD = None


def install_mysql():
    global MYSQL_ROOT_PASSWORD

    if MYSQL_ROOT_PASSWORD is None:
        MYSQL_ROOT_PASSWORD = getpass.getpass("Введіть пароль для користувача root MySQL: ")

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
            print("Сервіс MySQL був не активний і тепер запущено.")
        else:
            print("Сервіс MySQL вже запущено.")

    # Тут встановлюємо пароль для користувача root
    subprocess.run(["sudo", "mysqladmin", "-u", "root", "password", MYSQL_ROOT_PASSWORD])
    print("Пароль користувача root оновлено.")


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


def create_mysql_user(user, password):
    # Створення користувача MySQL, або оновлення паролю, якщо користувач існує
    try:
        import mysql.connector
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password=MYSQL_ROOT_PASSWORD
        )
        cursor = connection.cursor()
        cursor.execute(f"SELECT user FROM mysql.user WHERE user = '{user}'")
        existing_user = cursor.fetchone()

        if existing_user:
            # Користувач існує, оновлюємо пароль
            cursor.execute(f"ALTER USER '{user}'@'localhost' IDENTIFIED BY '{password}';")
            print(f"Пароль користувача '{user}' оновлено.")
        else:
            # Користувач не існує, створюємо його
            cursor.execute(f"CREATE USER '{user}'@'localhost' IDENTIFIED BY '{password}';")
            cursor.execute(f"GRANT ALL PRIVILEGES ON *.* TO '{user}'@'localhost' WITH GRANT OPTION;")
            print(f"Користувач '{user}' успішно створений з паролем: {password}")

        connection.commit()
    except mysql.connector.Error as err:
        print("Помилка MySQL:", err)
    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()


def create_database_and_table(user):
    connection = None  # Ініціалізуємо connection поза спробою з'єднання з базою даних
    try:
        import mysql.connector
        connection = mysql.connector.connect(
            host='localhost',
            user='tysser',
            password=user
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

# Генерація пароля для користувача "tysser"
password = generate_password()

# Створення користувача MySQL
user = "tysser"
create_mysql_user(user, password)

# Створення бази даних та таблиці "users"
create_database_and_table(user)

print(f"Ім'я користувача: {user}")
print(f"Пароль користувача: {password}")
print(f"MYSQL_ROOT_PASSWORD: {MYSQL_ROOT_PASSWORD}")

import docker

# Створюємо клієнт Docker, використовуючи змінні оточення
client = docker.from_env()

try:
    # Запускаємо контейнер Nginx, відображаючи порт 80 контейнера на порт 8080 хоста
    container = client.containers.run(
        "my-custom-nginx",  # Використовуйте ім'я вашого нового образу
        detach=True,  # Запуск в режимі фону
        ports={"80/tcp": 8080},  # Відображення портів
    )
    print(f"Контейнер Nginx запущено, ID: {container.id}")
    print("Доступ до Nginx можна отримати за адресою http://localhost:8080")
except Exception as e:
    print(f"Помилка при запуску контейнера Nginx: {e}")

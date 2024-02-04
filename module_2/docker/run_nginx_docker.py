import docker

# Створюємо клієнта Docker, використовуючи змінні середовища
client = docker.from_env()

try:
    # Запускаємо контейнер Nginx, відображаючи порт 80 контейнера на порт 8081 хосту
    container = client.containers.run(
        "my-custom-nginx",  # Ім'я вашого образу
        detach=True,  # Запуск у фоновому режимі
        ports={"80/tcp": 8081},  # Відображення портів
        name="my-nginx-container"  # Присвоюємо контейнеру ім'я для зручності
    )
    print(f"Контейнер Nginx запущено, ID: {container.id}")
    print("Доступ до Nginx можна отримати за адресою http://localhost:8081")
except Exception as e:
    print(f"Помилка при запуску контейнера Nginx: {e}")

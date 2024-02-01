import docker

# Створюємо клієнт Docker, використовуючи змінні оточення
client = docker.from_env()

try:
    # Запускаємо контейнер Nginx, відображаючи порт 80 контейнера на порт 8080 хоста
    container = client.containers.run("nginx:latest", detach=True, ports={"80/tcp": 8080})
    print(f"Nginx running, ID: {container.id}")
    print("Access in Nginx http://localhost:8080")
except Exception as e:
    print(f"Помилка при запуску контейнера Nginx: {e}")

import docker
from docker.errors import ImageNotFound, APIError

client = docker.from_env()

try:
    container = client.containers.run("nginx", detach=True, ports={'80/tcp': 8080})
    print(f"Nginx контейнер запущено с ID: {container.id}")
    print("Доступ до Nginx можна отримати через http://localhost:8080")
    logs = container.logs(tail=10)
    print(logs.decode("utf-8"))
except ImageNotFound:
    print("Образ 'nginx:latest' не знайдений. Завантаження...")
except APIError as e:
    print(f"Виникла помилка Docker API: {e}")
except Exception as e:
    print(f"невідома помилка: {e}")

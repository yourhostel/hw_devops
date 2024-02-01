import docker

client = docker.from_env()

container = client.containers.run("nginx", detach=True, ports={'80/tcp': 8080})

print(f"Nginx контейнер запущен с ID: {container.id}")
print("Доступ к Nginx можно получить через http://localhost:8080")

logs = container.logs(tail=10)
print(logs.decode("utf-8"))
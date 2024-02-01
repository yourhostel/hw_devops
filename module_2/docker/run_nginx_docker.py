import docker

client = docker.from_env()

container = client.containers.run("nginx", detach=True, ports={'80/tcp': 8080})

print(f"Nginx ID: {container.id}")
print("Access Nginx http://localhost:8080")

logs = container.logs()
print(logs.decode("utf-8"))
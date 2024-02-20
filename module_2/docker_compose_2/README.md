# Static nginx site
![static-nginx-site_1.jpg](screenshots%2Fstatic-nginx-site_1.jpg)
![static-nginx-site_2.jpg](screenshots%2Fstatic-nginx-site_2.jpg)
#### ["Search page by ip" homework 6 frontend](https://gitlab.com/yourhostel.ua/homework_advanced_js/-/tree/main/homework6-async-await)
![static-nginx-site_3.jpg](screenshots%2Fstatic-nginx-site_3.jpg)
# Persistent docker registry
![persistent_docker_registry_1.jpg](screenshots%2Fpersistent_docker_registry_1.jpg)
![persistent_docker_registry_2.jpg](screenshots%2Fpersistent_docker_registry_2.jpg)
![persistent_docker_registry_3.jpg](screenshots%2Fpersistent_docker_registry_3.jpg)
# Scale instance 1 - 3
![scale_instance_1.jpg](screenshots%2Fscale_instance_1.jpg)
![scale_instance_2.jpg](screenshots%2Fscale_instance_2.jpg)
![scale_instance_3.jpg](screenshots%2Fscale_instance_3.jpg)
####  Cкрипт update_nginx.sh 
 - оновлює конфігурацію NGINX відповідно до IP-адрес запущених контейнерів програми і перезапускає NGINX.
 - NGINX працює як балансувальник навантаження у цьому випадку. Він розподіляє запити між контейнерами.
 - nginx/default.conf генерується автоматично при оновленні, ip беруться з поточних працюючих контейнерів. Даний файл у репозиторії приклад генерації після роботи скрипту update_nginx.sh
![scale_instance_4.jpg](screenshots%2Fscale_instance_4.jpg)
# Volume to share
- Після запуску Docker Compose, сервіс writer створює файл shared_message.txt у загальному томі, а сервіс reader читає та виводить його вміст у консоль.
- ![volume_to_share.jpg](screenshots%2Fvolume_to_share.jpg)
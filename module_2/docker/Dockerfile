# Використовуємо базовий образ Ubuntu
FROM ubuntu:latest

# Встановлюємо необхідні пакети
RUN apt-get update && apt-get install -y nginx

# Додаємо користувача Test і створюємо домашній каталог
RUN useradd -ms /bin/bash Test

# Змінюємо власника деяких директорій (за потреби)
RUN chown -R Test:Test /var/www/html

# Вказуємо користувача за замовчуванням для контейнера
USER Test

# Вказуємо команду, яка виконується при запуску контейнера
CMD ["nginx", "-g", "daemon off;"]

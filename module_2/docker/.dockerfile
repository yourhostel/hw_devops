# Використовуємо базовий образ, наприклад, Ubuntu
FROM ubuntu:latest

# Додаємо декілька команд для налаштування користувача Test
# Додавання користувача
RUN useradd -ms /bin/bash Test

# Змінюємо власника директорії /tmp
RUN chown -R Test /tmp

# Вказуємо користувача, з яким буде запущений контейнер
USER Test

# Оновлюємо пакети та встановлюємо Nginx
RUN sudo apt-get update && sudo apt-get install -y nginx

# Команда, яка виконується при запуску контейнера (можна вказати свою)
CMD ["nginx", "-g", "daemon off;"]
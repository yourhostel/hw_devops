import threading


# Функція для пошуку рядка у файлі
def search_in_file(filename, search_string, found_event):
    with open(filename, 'r', encoding='utf-8') as file:  # Відкриваємо файл з вказанням кодування
        for line in file:  # Читаємо файл по рядку
            if search_string in line:  # Якщо знайдено шуканий рядок
                print(f"Знайдено в {filename}: {line.strip()}")  # Виводимо інформацію про знахідку
                found_event.set()  # Встановлюємо подію, щоб сигналізувати іншим потокам про знахідку
                return  # Виходимо з функції, щоб не шукати далі


# Подія для сповіщення між потоками, що рядок знайдено
found_event = threading.Event()

# Список файлів для пошуку і шуканий рядок
filenames = ['file1.txt', 'file2.txt']
search_string = "ШуканийРядок"

# Створення та запуск потоків для кожного файлу
threads = []
for filename in filenames:
    thread = threading.Thread(target=search_in_file, args=(filename, search_string, found_event))
    thread.start()
    threads.append(thread)

# Очікування завершення всіх потоків
for thread in threads:
    thread.join()

# Якщо подія не встановлена, значить рядок не було знайдено у жодному з файлів
if not found_event.is_set():
    print("Рядок не знайдено у жодному з файлів.")

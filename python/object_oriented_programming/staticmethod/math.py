class MathOperations:
    @staticmethod
    def factorial(n):
        if n == 0:
            return 1
        else:
            return n * MathOperations.factorial(n - 1)

    @staticmethod
    def fibonacci(n):
        """Повертає n число Фібоначчі"""
        if n <= 0:
            return 0
        elif n == 1:
            return 1
        else:
            a, b = 0, 1
            for _ in range(2, n + 1):
                a, b = b, a + b
            return b

    @staticmethod
    def print_names(names):
        """Takes a space-delimited string or an iterable"""
        try:
            for name in names.split():  # string case
                print(name)
        except AttributeError:  # iterable case
            for name in names:
                print(name)


# Виклик статичного методу без створення екземпляра класу
print(MathOperations.factorial(5))

n = 10  # Обчислити перші 10 чисел Фібоначчі
for i in range(n):
    print(MathOperations.fibonacci(i))

print("-----")
print(MathOperations.print_names("Takes a space-delimited string or an iterable"))
print("-----")
print(MathOperations.print_names(["Takes", "a", "space-delimited", "string", "or", "an", "iterable"]))
print("-----")


class UnitConverter:
    @classmethod
    def miles_to_kilometers(cls, miles):
        return miles * 1.60934


print(UnitConverter.miles_to_kilometers(5))


class Person:
    count = 0  # Атрибут класу для відстеження кількості людей

    def __init__(self, name, age):
        self.name = name
        self.age = age
        Person.count += 1  # Збільшуємо лічильник під час створення нової людини

    @classmethod  # Визначає метод як статичний, але має доступ до самого класу через параметр cls
    def create_person(cls, name, age):
        # Метод класу для створення нової людини
        return cls(name, age)  # Створюємо новий екземпляр класу

    @classmethod
    def get_total_count(cls):
        # Метод класу для отримання загальної кількості людей
        return cls.count


# Створюємо людей із використанням статичного методу
person1 = Person.create_person("Alice", 25)
person2 = Person.create_person("Bob", 30)

# Отримуємо загальну кількість людей з використанням методу класу
total_count = Person.get_total_count()

print(f"Total number of people: {total_count}")

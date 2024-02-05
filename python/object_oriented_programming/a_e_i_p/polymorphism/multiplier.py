# Якщо різні класи реалізують метод __call__, екземпляр функції (або інший об'єкт, що викликається) може обробляти їх
# без знання про конкретні типи цих об'єктів, що також є формою поліморфізму.

class Multiplier:
    def __init__(self, factor):
        self.factor = factor

    def __call__(self, x):
        if isinstance(x, Number):
            return x.multiply(self.factor)
        else:
            raise TypeError("Object does not support multiplication")


class Number:
    def __init__(self, value):
        self.value = value

    def multiply(self, factor):
        return self.value * factor

    def divide(self, divisor):
        # Перевірка, щоб уникнути ділення на нуль
        if divisor == 0:
            raise ValueError("Cannot divide by zero")
        return self.value / divisor


class Divider:
    def __init__(self, divisor):
        self.divisor = divisor

    def __call__(self, x):
        if isinstance(x, Number):
            return x.divide(self.divisor)
        else:
            raise TypeError("Object does not support division")

    # Припустимо, що ми маємо метод divide в класі Number
    # Це приклад для демонстрації, тому метод divide не реалізований


number = Number(10)
multiplier = Multiplier(5)
divider = Divider(2)

print(multiplier(number))  # Екземпляр Multiplier обробляє екземпляр Number
print(divider(number))  # Подібно до multiplier, але для поділу

# У цьому прикладі multiplier і divider можуть обробляти об'єкти різних класів (якби Number та інший клас
# підтримували відповідні операції), і можуть повертати різні результати залежно від переданих їм даних.

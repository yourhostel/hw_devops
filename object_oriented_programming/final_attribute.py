class FinalAttribute:
    def __init__(self, name=None, value=None):
        self.name = name  # Збереження імені атрибута
        self._value = value
        self._value_set = False

    def __get__(self, instance, owner):
        return self._value

    def __set__(self, instance, value):
        if self._value_set:
            raise AttributeError(f"You can't set value '{value}' to the {self.name} attribute - it is final")
        self._value = value
        self._value_set = True


class Dog:
    age = FinalAttribute("'age'")  # Ініціалізація не потрібна

    def __init__(self, age, color):
        self.age = age  # Установка можлива тільки один раз
        self.color = color

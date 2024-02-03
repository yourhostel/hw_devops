class FinalAttribute:
    def __init__(self, value=None):
        self._value = value
        self._value_set = False

    def __get__(self, instance, owner):
        return self._value

    def __set__(self, instance, value):
        if self._value_set:
            raise AttributeError("This attribute is final")
        self._value = value
        self._value_set = True


class Dog:
    age = FinalAttribute()  # Ініціалізація не потрібна

    def __init__(self, age):
        self.age = age  # Установка можлива тільки один раз

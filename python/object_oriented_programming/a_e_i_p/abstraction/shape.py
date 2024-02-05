from abc import ABC, abstractmethod


class Shape(ABC):
    @abstractmethod
    def area(self):
        # Метод для обчислення площі фігури
        pass

    @abstractmethod
    def perimeter(self):
        # Метод для обчислення периметра фігури
        pass


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        # Обчислення площі прямокутника
        return self.width * self.height

    def perimeter(self):
        # Обчислення периметра прямокутника
        return 2 * (self.width + self.height)


class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        # Обчислення площі кола
        return 3.14 * self.radius ** 2

    def perimeter(self):
        # Обчислення периметра кола
        return 2 * 3.14 * self.radius


# Створення об'єктів
rectangle = Rectangle(10, 20)
circle = Circle(5)

print(f"Area of the rectangle: {rectangle.area()}")
print(f"Area of the circle: {circle.area()}")


# Цей клас не реалізує абстрактний метод perimeter
class Circle_2(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14 * self.radius ** 2


# Спроба створити екземпляр Circle викличе TypeError
try:
    circle = Circle_2(5)
except TypeError as e:
    print(f"Error: {e}")

print("------ super() ------")


class BaseShape(ABC):
    def __init__(self, color):
        self.color = color

    @abstractmethod
    def area(self):
        pass

    def info(self):
        return f"Shape with color {self.color}"


class Circle(BaseShape):
    def __init__(self, color, radius):
        super().__init__(color)  # Ініціалізація атрибута базового класу
        self.radius = radius

    def area(self):
        return 3.14 * self.radius ** 2

    def info(self):
        # Розширення методу базового класу зі збереженням його функціональності
        base_info = super().info()
        return f"{base_info}, radius {self.radius}"


circle = Circle("red", 5)
print(circle.info())  # Виведе інформацію і з базового, і з дочірнього класу

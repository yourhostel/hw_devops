class Shape:
    def area(self):
        pass


class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height


class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14 * self.radius ** 2


def print_area(shape):
    print(shape.area())


rectangle = Rectangle(10, 20)
circle = Circle(5)

# Поліморфна взаємодія з об'єктами
print_area(rectangle)  # 200
print_area(circle)  # 78.5

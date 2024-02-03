class Dog:
    def __init__(self, color, eye_color, height, length, weight):
        self.color = color
        self.eye_color = eye_color
        self.__height = height  # Використовуємо захищений атрибут (name mangling) _Dog__height
        self.length = length
        self.weight = weight

    @property  # getter
    def height(self):
        return self.__height

    @height.setter  # setter
    def height(self, value):
        if value < 0:
            raise ValueError("Height cannot be negative")
        self.__height = value

    def sit(self):
        print(f"{self.color} dog sits.")

    def lay_down(self):
        print(f"{self.color} dog lays down.")

    def shake(self):
        print(f"{self.color} dog shakes.")

    def come(self):
        print(f"{self.color} dog comes to you.")

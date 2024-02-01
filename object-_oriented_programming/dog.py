class Dog:
    def __init__(self, color, eye_color, height, length, weight):
        self.color = color
        self.eye_color = eye_color
        self.height = height
        self.length = length
        self.weight = weight

    def sit(self):
        print(f"{self.color} dog sits.")

    def lay_down(self):
        print(f"{self.color} dog lays down.")

    def shake(self):
        print(f"{self.color} dog shakes.")

    def come(self):
        print(f"{self.color} dog comes to you.")
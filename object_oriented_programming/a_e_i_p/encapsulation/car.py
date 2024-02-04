class Car:
    def __init__(self, brand, model):
        self._brand = brand
        self._model = model

    def start(self):
        print(f"Starting the {self._brand} {self._model}")


my_car = Car("Toyota", "Camry")
my_car.start()
class Adder:
    def __init__(self, n):
        self.n = n

    def __call__(self, x):  # Метод __call__ дозволяє об'єктам класу "викликатися" як функції
        return self.n + x


# Об'єкт імітує поведінку функції
add_five = Adder(5)
print(add_five(10))

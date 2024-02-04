from dog import Dog

rayne = Dog("Gray, White, and Black", "Blue and Brown", 18, 36, 30)

rayne.sit()
rayne.__height = 15
print(rayne.__height)

print(rayne._Dog__height)

rayne._Dog__height = 7

print(rayne._Dog__height)

print("-------final-------")

from final_attribute import Dog

rayne = Dog(3, "grey")

try:
    rayne.color = "white"  # спроба змінити атрибут color
    rayne.age = 4  # спроба змінити final атрибут age
except AttributeError as error:
    print(f"Помилка: {error}")

print(f"age={rayne.age}")
print(f"dir(rayne) -> {dir(rayne)}")
print(f"filtered dir() -> {[attr for attr in dir(rayne) if not attr.startswith('__')]}")
print(f"vars(rayne) -> {vars(rayne)}")

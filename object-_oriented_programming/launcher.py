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

rayne = Dog(3)

try:
    rayne.age = 4
except AttributeError as error:
    print(f"Помилка: {error}")

print(rayne.age)

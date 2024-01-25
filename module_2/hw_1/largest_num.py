try:
    with open("count", "r") as file:
        numbers = [float(line.strip()) for line in file]
    largest_number = max(numbers)
    print("The largest number is:", largest_number)
except FileNotFoundError:
    print("Error: the file does not exist")
except ValueError:
    print("Error: the file contains non-numeric values")
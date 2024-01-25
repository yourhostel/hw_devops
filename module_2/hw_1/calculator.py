print("Simple calculator")


def format_number(n):
    return f"{n:.5f}".rstrip('0').rstrip('.') if '.' in f"{n:.2f}" else str(n)


while True:  # Infinite loop for repeating operations

    # Logic for getting numbers a и b
    while True:
        try:
            value_a = input("Enter a number for a: ")
            a = float(value_a)
            break
        except ValueError:
            print(f"'{value_a}' is not a number. Try again.")

    while True:
        operation = input("Enter *, /, + or -: ")
        if operation in ["+", "-", "*", "/"]:
            break  # Exit the loop if the operation is valid
        else:
            print("Unknown character. Please enter *, /, + or -.")

    while True:
        try:
            value_b = input("Enter a number for b: ")
            b = float(value_b)
            break
        except ValueError:
            print(f"'{value_b}' is not a number. Try again.")

    match operation:
        case "+":
            result = a + b
        case "-":
            result = a - b
        case "*":
            result = a * b
        case "/":
            if b != 0:
                result = a / b
            else:
                print("Error: Division by zero")
                continue  # Return to the beginning of the loop

    # Processing the result output
    formatted_a = format_number(a)
    formatted_b = format_number(b)
    formatted_result = format_number(result)
    print(f"{formatted_a} {operation} {formatted_b} = {formatted_result}")

    # Request to continue work
    if input("Perform another operation (Y/N)? ").upper() != "Y":
        break  # Exit outer loop if no response "Y"

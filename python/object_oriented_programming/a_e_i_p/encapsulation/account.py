class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.__balance = balance

    def deposit(self, amount):
        if amount > 0:
            self.__balance += amount
            print(f"Added {amount} to the balance")

    def withdraw(self, amount):
        if 0 < amount <= self.__balance:
            self.__balance -= amount
            print(f"Withdrew {amount} from the balance")
        else:
            print("Insufficient balance")

    def get_balance(self):
        return self.__balance


acc = Account("John")
acc.deposit(100)
print(acc.get_balance())  # Доступ до балансу через метод
acc.withdraw(50)

def create_counter_1():  # генерація на замиканні
    count = 0

    def increment():
        nonlocal count
        count += 1
        print(count)

    return increment


counter_1 = create_counter_1()
counter_1()


def create_counter_2():  # генерація за допомогою функції-генератора
    count = 0
    while True:
        count += 1
        yield count


counter_2 = create_counter_2()
next(counter_2)


def create_counter_3():  # крутий варіант через рекурсію
    count = 0

    def increment():
        nonlocal count
        count += 1
        print(count)
        return increment

    return increment


counter_3 = create_counter_3()

counter_3()()


def create_counter_4():  # і найкрутіший варіант за допомогою об'єкта-класу та замиканні
    count = 0

    class Increment:
        def __call__(self):  # для того, щоб екземпляри цього класу могли бути викликані як функції
            nonlocal count
            count += 1
            print(count)
            return self

        def __repr__(self):  # виводимо пустий рядок замість інформації про об'єкт
            return ""

    return Increment()


counter_4 = create_counter_4()

counter_4()()

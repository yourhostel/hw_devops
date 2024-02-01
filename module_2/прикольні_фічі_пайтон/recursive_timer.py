import time


def recursive_timer(milliseconds, callback):
    if milliseconds <= 0:
        callback()
    else:
        time.sleep(0.001)  # Затримка на 1 мілісекунду (0.001 секунд)
        recursive_timer(milliseconds - 1, callback)


delay_in_milliseconds = 997  # 5 секунд


def callback_function():
    print(f" Таймер зупинився після {delay_in_milliseconds} мілісекунд.")


recursive_timer(delay_in_milliseconds, callback_function)

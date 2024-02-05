import sys

for key, value in {"Bool": False, "None": None, "0": 0, "set": set(), "порожній рядок": "", "порожній список": [], "порожній словник": {}, "порожній кортеж": ()}.items():
    print(f"{key}={sys.getsizeof(value)}")
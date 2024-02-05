class India:
    def capital(self):
        print("New Delhi is the capital of India.")


class USA:
    def capital(self):
        print("Washington, D.C. is the capital of USA.")


def describe_country(country):
    country.capital()


india = India()
usa = USA()

describe_country(india)  # New Delhi is the capital of India.
describe_country(usa)  # Washington, D.C. is the capital of USA.

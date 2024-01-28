import requests
from termcolor import colored


def web_check(web_site):
    print('\033[95m' + web_site + '\033[95m')
    result = requests.get(web_site)
    print(result.status_code)
    if result.status_code == 200:
        print(colored("Site is OK", "green", "on_red"))
    else:
        print(colored("Some Error, site is not working", "red"))

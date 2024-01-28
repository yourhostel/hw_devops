#!/usr/bin/env python3

import json
from colorama import init
import sys

from web_checker import web_check

init()

if len(sys.argv) < 2:
    print("Usage: python script.py <path_to_config_file>")
    sys.exit(1)

file_path = sys.argv[1]

f = open(file_path)
content = f.read()
config = json.loads(content)

for web_site in config.keys():
    web_check(config[web_site])

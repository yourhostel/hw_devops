# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests
import time

# Loading input data from Terraform
input_data = json.load(sys.stdin)
# print(json.dumps(input_data))

# Extracting parameters for the request
url = input_data["url"]
auth_token = input_data["auth_token"]
data_param = input_data["data"]
subdomain_id = input_data["subdomain_id"]
priority = input_data["priority"]

# Setting up headers and data for the POST request
headers = {
    "Authorization": "Bearer " + auth_token,
    "Content-Type": "application/x-www-form-urlencoded"
}
data = {
    "data": data_param,
    "subdomain_id": subdomain_id,
    "priority": priority
}

# Sending the POST request
response = requests.post(url, headers=headers, data=data)


def convert_to_string_and_copy(source, target):
    if isinstance(source, dict):
        for k, v in source.items():
            target[str(k)] = convert_to_string_and_copy(v, {})
    elif isinstance(source, list):
        list_as_dict = {}
        for i, item in enumerate(source):
            list_as_dict[str(i)] = convert_to_string_and_copy(item, {})
        return list_as_dict
    else:
        return str(source)
    return target


data = requests.post(url, headers=headers, data=data).json()

json_data = {}
json_data = convert_to_string_and_copy(data, json_data)


print(json.dumps(json_data, ensure_ascii=False))
time.sleep(5)


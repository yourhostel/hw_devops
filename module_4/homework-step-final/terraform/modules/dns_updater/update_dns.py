# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests

input_data = json.load(sys.stdin)

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

response = requests.post(url, headers=headers, data=data).json()


# Recursive processing of the response object from the hosting provider
def flatten_to_string(obj, parent_key='', sep='_'):
    items = {}
    if isinstance(obj, dict):
        for k, v in obj.items():
            new_key = f"{parent_key}{sep}{k}" if parent_key else str(k)
            items.update(flatten_to_string(v, new_key, sep=sep))
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            new_key = f"{parent_key}{sep}{i}" if parent_key else str(i)
            items.update(flatten_to_string(item, new_key, sep=sep))
    else:
        items[parent_key] = str(obj)
    return items


flattened_response = flatten_to_string(response)
print(json.dumps(flattened_response, ensure_ascii=False))

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

response = requests.post(url, headers=headers, data=data).json()
#response = {
#  "result": True,
#  "response": {"callback": "13.48.109.31"},
#  "messages": {"success": ["Готово"]}
#}


#def stringify(obj):
#    if isinstance(obj, dict):
#        return json.dumps({k: stringify(v) for k, v in obj.items()}, ensure_ascii=False)
#    elif isinstance(obj, list):
#        return json.dumps([stringify(v) for v in obj], ensure_ascii=False)
#    elif isinstance(obj, bool):
#        return str(obj).lower()
#    else:
#        return str(obj)

#json_string = stringify(response)
#print(json_string)

#def flatten_and_stringify(data, result=None):
#    if result is None:
#        result = {}
#    if isinstance(data, dict):
#        for k, v in data.items():
#            if isinstance(v, (dict, list)):
#                flatten_and_stringify(v, result)
#            else:
#                result[str(k)] = str(v)
#    elif isinstance(data, list):
#        for item in data:
#            flatten_and_stringify(item, result)
#    return result
#
#flattened_response = flatten_and_stringify(response)
#print(json.dumps(flattened_response, ensure_ascii=False))

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

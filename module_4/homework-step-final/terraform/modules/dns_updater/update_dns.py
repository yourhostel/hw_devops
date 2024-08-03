# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests

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


def convert_bool_to_string(obj):
    if isinstance(obj, dict):
        return {k: convert_bool_to_string(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_bool_to_string(elem) for elem in obj]
    elif isinstance(obj, bool):
        return str(obj).lower()
    return obj


json_data = convert_bool_to_string(response.json())
print(json.dumps({"result": "true"}))



# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests

input_data = json.load(sys.stdin)

# Extracting parameters for the request
url = input_data["url"]
auth_token = input_data["auth_token"]
dns_record_ips = input_data["data"].split(",")
subdomain_ids = input_data["subdomain_ids"].split(",")
priority = input_data["priority"]

# Setting up headers
headers = {
    "Authorization": "Bearer " + auth_token,
    "Content-Type": "application/x-www-form-urlencoded"
}

# Creating an empty JSON object to store the responses
responses = {}

# Processing each IP and its corresponding subdomain ID
# Using zip to pair each IP with its subdomain ID
for ip, subdomain_id in zip(dns_record_ips, subdomain_ids):
    data = {
        "data": ip,
        "subdomain_id": subdomain_id,
        "priority": priority
    }
    response = requests.post(url, headers=headers, data=data).json()
    responses[ip] = response  # Storing response under the IP key


# Recursive processing of the responses
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


flattened_responses = flatten_to_string(responses)
print(json.dumps(flattened_responses, ensure_ascii=False))

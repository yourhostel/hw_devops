# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests
from response_processor import flatten_to_string

input_data = json.load(sys.stdin)

# Extracting parameters for the request
url = input_data["url"]
auth_token = input_data["auth_token"]
dns_record_ips = input_data["data"].split(",")
subdomain_alias = input_data.get("subdomain_alias")
subdomain_alias_id = input_data.get("subdomain_alias_id")
subdomain_ids = input_data["subdomain_ids"].split(",")
priority = input_data["priority"]

# Setting up headers
headers = {
    "Authorization": "Bearer " + auth_token,
    "Content-Type": "application/x-www-form-urlencoded"
}

# Creating an empty JSON object to store the responses
responses = {}

# Checking if subdomain alias is provided and make a single request
if subdomain_alias and subdomain_alias_id:
    data = {
        "data": subdomain_alias,
        "subdomain_id": subdomain_alias_id,
        "priority": priority
    }
    response = requests.post(url, headers=headers, data=data).json()
    responses[subdomain_alias] = response
else:
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

flattened_responses = flatten_to_string(responses)
print(json.dumps(flattened_responses, ensure_ascii=False))


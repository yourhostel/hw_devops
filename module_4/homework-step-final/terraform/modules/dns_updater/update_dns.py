# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests
import time
from response_processor import flatten_to_string

input_data = json.load(sys.stdin)

# Extracting parameters for the request
url = input_data["url"]
auth_token = input_data["auth_token"]
dns_record_ips = input_data["data"].split(",")
subdomain_ids = input_data["subdomain_ids"].split(",")
subdomain_alias = input_data.get("subdomain_alias")
subdomain_alias_id = input_data.get("subdomain_alias_id")
priority = input_data["priority"]

# Setting up headers
headers = {
    "Authorization": "Bearer " + auth_token,
    "Content-Type": "application/x-www-form-urlencoded"
}

# Creating an empty JSON object to store the responses
responses = {}

# Check if the subdomain alias is provided and make a single request
if subdomain_alias and subdomain_alias_id:
    max_attempts = 10
    attempt = 0
    successful = False

    while attempt < max_attempts and not successful:
        data = {
            "data": subdomain_alias,
            "subdomain_id": subdomain_alias_id,
            "priority": priority
        }
        response = requests.post(url, headers=headers, data=data)
        if response.status_code == 200:
            successful = True
        else:
            time.sleep(30)  # Wait before retrying
        attempt += 1

    if successful:
        responses[subdomain_alias] = response.json()
    else:
        responses['error'] = "Failed to update DNS after multiple attempts"
else:
    # Processing each IP and its corresponding subdomain ID using zip
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



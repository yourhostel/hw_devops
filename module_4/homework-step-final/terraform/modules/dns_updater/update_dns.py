# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests

# Loading input data from Terraform
input_data = json.load(sys.stdin)

# Parameters for the request
url = input_data["query"]["url"]
headers = {
    "Authorization": "Bearer " + input_data["query"]["auth_token"],
    "Content-Type": "application/x-www-form-urlencoded"
}
data = {
    "data": input_data["query"]["data"],
    "subdomain_id": input_data["query"]["subdomain_id"],
    "priority": input_data["query"]["priority"]
}

# Sending a POST request
response = requests.post(url, headers=headers, data=data)
output = {"status_code": response.status_code, "body": response.json()}

# Output the result for Terraform
print(json.dumps(output))


# terraform/modules/dns_updater/update_dns.py

import sys
import json
import requests

# Loading input data from Terraform
input_data = json.load(sys.stdin)
print("Complete input data:")
print("Complete input data:", input_data)
# Since data is nested under 'query', we need to extract it correctly
query_data = input_data["query"]

# Displaying the received data
print("Received data:", query_data)

# Extracting parameters for the request
url = query_data["url"]
auth_token = query_data["auth_token"]
data_param = query_data["data"]
subdomain_id = query_data["subdomain_id"]
priority = query_data["priority"]

# Displaying extracted parameters
print("URL:", url)
print("Auth Token:", auth_token)
print("Data:", data_param)
print("Subdomain ID:", subdomain_id)
print("Priority:", priority)

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
output = {"status_code": response.status_code, "body": response.json()}

# Displaying the response
print("Response Status Code:", response.status_code)
print("Response Body:", response.json())

# Output the result for Terraform
print(json.dumps(output))




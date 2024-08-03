# terraform/modules/dns_updater/main.tf

terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.4.3"
    }
  }
}

data "external" "update_dns_record" {
  program = ["python3", "${path.module}/update_dns.py"]

  query = {
    timestamp    = timestamp()
    url          = var.url_update_dns
    auth_token   = var.auth_token
    data         = var.dns_record_ip
    subdomain_id = var.dns_record_id
    priority     = "0"
  }
#  query =  {
#     "status": "ok",
#     "message": "DNS record updated",
#     "ip": "1.2.3.4"
#  }

}

output "response_update_dns" {
  value = data.external.update_dns_record.result
}
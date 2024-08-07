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
    subdomain_alias = var.subdomain_alias
    subdomain_alias_id = var.subdomain_alias_id
    data         = join(",", var.dns_record_ips)
    subdomain_ids = join(",", var.dns_record_ids)
    priority     = "0"
  }
}

output "response_update_dns" {
  value = data.external.update_dns_record.result
}
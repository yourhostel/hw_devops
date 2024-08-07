# terraform/modules/dns_updater/variables.tf

variable "auth_token" {
  type = string
}

variable "subdomain_alias" {
  type = string
}

variable "subdomain_alias_id" {
  type = string
}

variable "dns_record_ids" {
  type = list(string)
}

variable "url_update_dns" {
  type = string
}

variable "dns_record_ips" {
  type = list(string)
}
# terraform/modules/dns_updater/variables.tf

variable "auth_token" {
  type = string
}

variable "dns_record_id" {
  type = string
}

variable "url_update_dns" {
  type = string
}

variable "dns_record_ips" {
  type = list(string)
}
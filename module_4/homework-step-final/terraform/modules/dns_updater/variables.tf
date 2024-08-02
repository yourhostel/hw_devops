# terraform/modules/dns_updater/variables.tf

variable "auth_token" {
  type = string
}

variable "dns_record_id" {
  type = number
}

variable "url_update_dns" {
  type = string
}

variable "dns_record_ip" {
  type = string
}
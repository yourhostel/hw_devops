# terraform/modules/cert_manager/variables.tf

variable "namespace" {
  default = "cert-manager"
}

variable "issuer_name" {
  default = "letsencrypt-prod"
}

variable "ingress_class" {
  default = "nginx"
}

variable "cert_manager_email" {
  default = "yourhostel.ua@gmail.com"
}

variable "acme_server" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}


# terraform/modules/ingress/variables.tf

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}
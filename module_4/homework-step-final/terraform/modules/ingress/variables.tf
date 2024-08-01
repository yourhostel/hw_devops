# terraform/modules/ingress/variables.tf

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "elastic_ip_allocation_ids" {
  description = "Allocation IDs of the Elastic IPs for NLB"
  type        = list(string)
}
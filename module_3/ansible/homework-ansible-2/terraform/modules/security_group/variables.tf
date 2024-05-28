# homework-ansible-1/terraform/security_group/variables.tf

variable "name" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "open_ports" {
  description = "List of ports to open in the security group"
  type        = list(number)
}

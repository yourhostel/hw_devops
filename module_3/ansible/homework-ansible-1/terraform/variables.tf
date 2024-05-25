# homework-ansible-1/terraform/variables.tf

variable "name" {
  description = "Prefix for resource names"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "open_ports" {
  description = "List of ports to open in the security group"
  type        = list(number)
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}
# Step_Project_3/terraform/load_balancer/variables.tf

variable "name" {
  description = "The name prefix for all resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs."
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string
}

variable "instance_ids" {
  description = "List of instance IDs."
  type        = list(string)
}


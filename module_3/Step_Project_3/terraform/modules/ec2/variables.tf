# Step_Project_3/terraform/ec2/variables.tf

variable "name" {
  description = "The name prefix for all resources."
  type        = string
}

variable "instance_count" {
  description = "The number of instances to create."
  type        = number
}

variable "ami_id" {
  description = "The AMI ID for the instances."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs."
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string
}

variable "ansible_user" {
  description = "The user for Ansible connections."
  type        = string
}

variable "private_key" {
  description = "The path to the private SSH key."
  type        = string
}

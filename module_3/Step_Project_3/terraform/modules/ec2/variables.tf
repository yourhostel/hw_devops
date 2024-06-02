# Step_Project_3/terraform/ec2/variables.tf

variable "name" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "ansible_user" {
  type = string
}

variable "ansible_port" {
  type = number
}

variable "private_key" {
  type = string
}


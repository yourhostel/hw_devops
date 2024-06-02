# Step_Project_3/terraform/load_balancer/variables.tf

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}



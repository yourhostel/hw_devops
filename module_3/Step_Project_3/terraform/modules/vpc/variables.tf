# Step_Project_3/terraform/modules/vpc/variables.tf

variable "name" {
  description = "The name prefix for all resources."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "vpc_azs" {
  description = "A list of availability zones."
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "A list of private subnet CIDR blocks."
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "A list of public subnet CIDR blocks."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT gateway."
  type        = bool
}

variable "single_nat_gateway" {
  description = "Whether to create a single NAT gateway."
  type        = bool
}





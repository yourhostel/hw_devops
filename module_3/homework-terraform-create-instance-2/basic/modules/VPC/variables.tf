# modules/VPC/variables.tf

variable "name" {
  description = "Name of the VPC and related resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnets_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}

variable "public_subnets_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

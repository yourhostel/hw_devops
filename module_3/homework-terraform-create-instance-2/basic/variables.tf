# variables.tf

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

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for the EC2 instances"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "open_ports" {
  description = "List of ports to be opened"
  type        = list(number)
}
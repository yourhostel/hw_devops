# homework-ansible-1/terraform/variables.tf

variable "name" {
  description = "Universal prefix for names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
}

variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Create a single NAT Gateway"
  type        = bool
}

variable "ansible_user" {
  description = "User for Ansible"
  type        = string
}

variable "ansible_port" {
  description = "Port for Ansible"
  type        = number
}

variable "prometheus_port" {
  description = "Port for Prometheus"
  type        = number
}

variable "grafana_port" {
  description = "Port for Grafana"
  type        = number
}

variable "node_exporter_port" {
  description = "Port for Node Exporter"
  type        = number
}

variable "cadvisor_port" {
  description = "Port for cAdvisor"
  type        = number
}

variable "private_key" {
  description = "Path to the private SSH key"
  type        = string
}




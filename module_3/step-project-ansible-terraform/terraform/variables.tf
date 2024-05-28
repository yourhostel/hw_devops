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

variable "prometheus_port" {
  description = "Port number for Prometheus"
  type        = number
  default     = 9090
}

variable "grafana_port" {
  description = "Port number for Grafana"
  type        = number
  default     = 3000
}

variable "node_exporter_port" {
  description = "Port number for Node Exporter"
  type        = number
  default     = 9100
}
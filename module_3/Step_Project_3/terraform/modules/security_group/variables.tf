# Step_Project_3/terraform/security_group/variables.tf

variable "name" {
  description = "The name prefix for all resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "prometheus_port" {
  description = "Port for Prometheus."
  type        = number
}

variable "grafana_port" {
  description = "Port for Grafana."
  type        = number
}

variable "node_exporter_port" {
  description = "Port for Node Exporter."
  type        = number
}

variable "cadvisor_port" {
  description = "Port for cAdvisor."
  type        = number
}



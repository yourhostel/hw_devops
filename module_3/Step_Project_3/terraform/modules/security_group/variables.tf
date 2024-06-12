# Step_Project_3/terraform/security_group/variables.tf

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "prometheus_port" {
  type = number
  description = "Prometheus port"
}

variable "grafana_port" {
  type = number
  description = "Grafana port"
}

variable "node_exporter_port" {
  type = number
  description = "Node Exporter port"
}

variable "cadvisor_port" {
  type = number
  description = "cAdvisor port"
}




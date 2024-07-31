# terraform/modules/ingress/variables.tf

variable "cluster_endpoint" {
  description = "Endpoint for the Kubernetes cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "CA certificate for the Kubernetes cluster"
  type        = string
}

variable "cluster_token" {
  description = "Token for accessing the Kubernetes cluster"
  type        = string
}

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}
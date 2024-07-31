# terraform/modules/cluster/variables.tf

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "region" {
  description = "AWS region where the resources will be created"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnets_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "tags" {
  description = "Map of tags to apply to all resources created"
  type        = map(string)
}

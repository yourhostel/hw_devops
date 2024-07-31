# terraform/variables.tf

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "subnets_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources created"
  type        = map(string)
}

variable "region" {
  description = "AWS region"
  default     = "eu-north-1"
  type        = string
}

variable "iam_profile" {
  description = "Profile of aws creds"
  default     = null
  type        = string
}

variable "zone_name" {
  description = "DNS Zone name"
  default     = ""
  type        = string
}

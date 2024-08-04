# terraform/variables.tf

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
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

variable "auth_token" {
  description = "Token hosting provider where we update A record"
  type = string
}

variable "subdomain_alias_id" {
  type = string
}

variable "dns_record_ids" {
  description = "Unique domain id from hosting provider"
  type = list(string)
}

variable "url_update_dns" {
  description = "Endpoint update dns record"
  type = string
}

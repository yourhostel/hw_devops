variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "open_ports" {
  description = "List of ports to be opened"
  type        = list(number)
  default     = [80, 443, 22]
}
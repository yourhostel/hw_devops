variable "open_ports" {
  description = "List of ports to be opened"
  type        = list(number)
  default     = [80, 443, 22]
}


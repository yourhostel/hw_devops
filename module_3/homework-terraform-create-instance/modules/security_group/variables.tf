variable "vpc_id" {
  description = "ID VPC, де буде створена група безпеки"
  type        = string
}

variable "open_ports" {
  description = "Список портів, які будуть відкриті"
  type        = list(number)
}
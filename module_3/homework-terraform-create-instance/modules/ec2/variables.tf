variable "subnet_id" {
  description = "ID підмережі, де буде розташовано інстанс"
  type        = string
}

variable "security_group_id" {
  description = "ID групи безпеки для інстансу"
  type        = string
}

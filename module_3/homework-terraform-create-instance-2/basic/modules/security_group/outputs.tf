# modules/security_group/outputs.tf

output "security_group_id" {
  value = aws_security_group.yourhostel_allow_ports.id
}

# homework-ansible-1/terraform/security_group/outputs.tf

output "security_group_id" {
  value = aws_security_group.this.id
}
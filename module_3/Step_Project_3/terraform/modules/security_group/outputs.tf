# Step_Project_3/terraform/security_group/outputs.tf

output "security_group_id" {
  description = "The ID of the security group."
  value       = aws_security_group.this.id
}



# Step_Project_3/terraform/ec2/outputs.tf

output "instance_ids" {
  description = "The IDs of the instances."
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "The public IPs of the instances."
  value       = aws_instance.this[*].public_ip
}

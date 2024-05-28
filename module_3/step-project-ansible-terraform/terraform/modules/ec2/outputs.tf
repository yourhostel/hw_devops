# homework-ansible-1/terraform/ec2/outputs.tf

output "instances" {
  value = aws_instance.this[*].id
}

output "public_ips" {
  value = aws_instance.this[*].public_ip
}
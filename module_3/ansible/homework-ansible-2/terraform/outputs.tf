# homework-ansible-1/terraform/outputs.tf

output "public_ips" {
  value = module.ec2.public_ips
}

output "instances" {
  value = module.ec2.instances
}

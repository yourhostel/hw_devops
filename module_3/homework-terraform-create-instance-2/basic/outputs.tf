# outputs.tf

output "vpc_id" {
  value = module.yourhostel_vpc.vpc_id
}

output "public_subnets" {
  value = module.yourhostel_vpc.public_subnets
}

output "private_subnets" {
  value = module.yourhostel_vpc.private_subnets
}

output "public_subnet_names" {
  value = module.yourhostel_vpc.public_subnet_names
}

output "private_subnet_names" {
  value = module.yourhostel_vpc.private_subnet_names
}

output "public_instance_ip" {
  value = module.ec2.public_instance_ip
}

output "private_instance_ip" {
  value = module.ec2.private_instance_ip
}


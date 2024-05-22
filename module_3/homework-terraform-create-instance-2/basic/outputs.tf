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

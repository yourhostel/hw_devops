# main.tf

module "yourhostel_vpc" {
  source                = "./modules/VPC"
  name                  = var.name
  vpc_cidr              = var.vpc_cidr
  private_subnets_cidrs = var.private_subnets_cidrs
  public_subnets_cidrs  = var.public_subnets_cidrs
  region                = var.region
}

module "yourhostel_security_group" {
  source                = "./modules/security_group"
  vpc_id                = module.yourhostel_vpc.vpc_id
  open_ports            = var.open_ports
}

module "ec2" {
  source                = "./modules/ec2"
  name                  = var.name
  ami                   = var.ami
  instance_type         = var.instance_type
  public_subnet_id      = module.yourhostel_vpc.public_subnets[0]
  private_subnet_id     = module.yourhostel_vpc.private_subnets[0]
  security_group_id     = module.yourhostel_security_group.security_group_id
  key_name              = var.key_name
}

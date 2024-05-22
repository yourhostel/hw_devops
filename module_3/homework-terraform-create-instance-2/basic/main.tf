module "vpc" {
  source              = "./modules/VPC"
  name                = var.name
  vpc_cidr            = var.vpc_cidr
  private_subnets_cidrs = var.private_subnets_cidrs
  public_subnets_cidrs  = var.public_subnets_cidrs
  region              = var.region
}

module "ec2" {
  source              = "./modules/EC2"
  name                = var.name
  ami                 = var.ami
  instance_type       = var.instance_type
  public_subnet_id    = module.vpc.public_subnets[0]
  private_subnet_id   = module.vpc.private_subnets[0]
  key_name            = var.key_name
}

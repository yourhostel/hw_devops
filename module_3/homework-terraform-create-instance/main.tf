module "yourhostel_vpc" {
  source = "./modules/vpc"
}

module "yourhostel_security_group" {
  source     = "./modules/security_group"
  vpc_id     = module.yourhostel_vpc.vpc_id
  open_ports = var.open_ports
}

module "yourhostel_ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.yourhostel_vpc.subnet_id
  security_group_id = module.yourhostel_security_group.security_group_id
}



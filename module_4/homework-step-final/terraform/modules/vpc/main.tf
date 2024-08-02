# main.tf

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  tags            = var.tags
  providers       = { aws = aws }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

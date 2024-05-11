terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48.0"
    }
  }
  required_version = ">= 1.8.2"
}

provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "network" {
  source = "./modules/network"
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}


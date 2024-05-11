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
  region = "eu-north-1" # регіон
}

module "vpc" {
  source = "./modules/vpc"
}

module "network" {
  source = "./modules/network"
}

module "security_group" {
  source = "./modules/security_group"
}

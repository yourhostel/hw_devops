# homework-ansible-1/terraform/providers.tf

provider "aws" {
  region = var.region
}

provider "template" {}

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}
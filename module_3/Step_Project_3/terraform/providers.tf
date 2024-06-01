# Step_Project_3/terraform/providers.tf

provider "aws" {
  region = var.aws_region
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
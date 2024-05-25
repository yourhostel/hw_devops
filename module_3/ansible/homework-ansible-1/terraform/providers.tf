# homework-ansible-1/terraform/providers.tf

provider "aws" {
  region = var.region
}

provider "template" {}
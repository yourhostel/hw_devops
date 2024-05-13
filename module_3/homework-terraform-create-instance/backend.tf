terraform {
  backend "s3" {
    bucket         = "terraform-state-danit-devops-2"
    key            = "states/yourhostel.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

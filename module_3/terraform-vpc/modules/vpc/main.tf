resource "aws_vpc" "yourhostel_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "yourhostel-vpc"
  }
}

resource "aws_internet_gateway" "yourhostel_igw" {
  vpc_id = aws_vpc.yourhostel_vpc.id

  tags = {
    Name = "yourhostel-igw"
  }
}

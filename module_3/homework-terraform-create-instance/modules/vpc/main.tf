resource "aws_vpc" "yourhostel_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "yourhostel-vpc"
  }
}

resource "aws_subnet" "yourhostel_subnet" {
  vpc_id            = aws_vpc.yourhostel_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "yourhostel-subnet"
  }
}

resource "aws_internet_gateway" "yourhostel_igw" {
  vpc_id = aws_vpc.yourhostel_vpc.id

  tags = {
    Name = "yourhostel-igw"
  }
}

resource "aws_route_table" "yourhostel_route_table" {
  vpc_id = aws_vpc.yourhostel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.yourhostel_igw.id
  }

  tags = {
    Name = "yourhostel-route-table"
  }
}

resource "aws_route_table_association" "yourhostel_association" {
  subnet_id      = aws_subnet.yourhostel_subnet.id
  route_table_id = aws_route_table.yourhostel_route_table.id
}

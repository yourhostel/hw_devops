variable "vpc_id" {}
variable "igw_id" {}

resource "aws_subnet" "yourhostel_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "yourhostel-subnet"
  }
}

resource "aws_route_table" "yourhostel_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "yourhostel-route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.yourhostel_subnet.id
  route_table_id = aws_route_table.yourhostel_route_table.id
}


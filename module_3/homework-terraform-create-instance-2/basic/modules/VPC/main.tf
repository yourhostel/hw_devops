# modules/VPC/main.tf

resource "aws_vpc" "yourhostel_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "yourhostel_igw" {
  vpc_id = aws_vpc.yourhostel_vpc.id

    tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "yourhostel_public_subnet" {
  count = length(var.public_subnets_cidrs)

  vpc_id            = aws_vpc.yourhostel_vpc.id
  cidr_block        = var.public_subnets_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

resource "aws_subnet" "yourhostel_private_subnet" {
  count = length(var.private_subnets_cidrs)

  vpc_id            = aws_vpc.yourhostel_vpc.id
  cidr_block        = var.private_subnets_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

resource "aws_nat_gateway" "yourhostel_nat" {
  allocation_id = aws_eip.yourhostel_eip.id
  subnet_id     = aws_subnet.yourhostel_public_subnet[0].id

  tags = {
    Name = "${var.name}-nat"
  }
}

resource "aws_eip" "yourhostel_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-eip"
  }
}

resource "aws_route_table" "yourhostel_public_route_table" {
  vpc_id = aws_vpc.yourhostel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.yourhostel_igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table_association" "yourhostel_public_rt_association" {
  count = length(var.public_subnets_cidrs)

  subnet_id      = aws_subnet.yourhostel_public_subnet[count.index].id
  route_table_id = aws_route_table.yourhostel_public_route_table.id
}

resource "aws_route_table" "yourhostel_private_route_table" {
  vpc_id = aws_vpc.yourhostel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.yourhostel_nat.id
  }

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route_table_association" "yourhostel_private_rt_association" {
  count = length(var.private_subnets_cidrs)

  subnet_id      = aws_subnet.yourhostel_private_subnet[count.index].id
  route_table_id = aws_route_table.yourhostel_private_route_table.id
}


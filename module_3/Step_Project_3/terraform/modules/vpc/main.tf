# Step_Project_3/terraform/modules/vpc/main.tf

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name                 = var.name
  cidr                 = var.vpc_cidr
  azs                  = var.vpc_azs
  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway

  tags = {
    Name      = var.name
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }
  public_subnet_tags = {
    Name      = "${var.name}-public"
    Owner     = "${var.name}"
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }
  private_subnet_tags = {
    Name      = "${var.name}-private"
    Owner     = "${var.name}"
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }
}

data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [module.vpc.vpc_id]
  }
}

resource "aws_internet_gateway" "this" {
  count = length(data.aws_internet_gateway.existing.id) == 0 ? 1 : 0

  vpc_id = module.vpc.vpc_id

  tags = {
    Name      = "${var.name}-igw"
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = length(data.aws_internet_gateway.existing.id) > 0 ? data.aws_internet_gateway.existing.id : aws_internet_gateway.this[0].id
  }

  tags = {
    Name      = "${var.name}-public-rt"
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }
}

resource "aws_route_table_association" "public" {
  count = length(module.vpc.public_subnets)

  subnet_id      = element(module.vpc.public_subnets, count.index)
  route_table_id = aws_route_table.public.id

  lifecycle {
    create_before_destroy = true
  }
}









# modules/EC2/main.tf

resource "aws_instance" "yourhostel_public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  key_name      = var.key_name

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_instance" "yourhostel_private_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name      = var.key_name

  tags = {
    Name = "${var.name}-private"
  }
}




# homework-ansible-1/terraform/ec2/main.tf

resource "aws_instance" "this" {
  count = var.count

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-ansible-${count.index + 1}"
  }
}

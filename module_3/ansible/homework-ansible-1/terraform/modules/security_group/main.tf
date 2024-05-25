# homework-ansible-1/terraform/security_group/main.tf

resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.open_ports[0]
    to_port     = var.open_ports[0]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-security-group"
  }
}

resource "aws_security_group" "yourhostel_allow_ports" {
  vpc_id      = var.vpc_id
  description = "Allows access from any location to the specified ports"

  dynamic "ingress" {
    # Використання dynamic для for_each
    for_each = var.open_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    # Використання count для створення egress правил для прикладу
    count       = length(var.open_ports)
    from_port   = var.open_ports[count.index]
    to_port     = var.open_ports[count.index]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "yourhostel-open-ports"
  }
}


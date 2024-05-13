resource "aws_security_group" "yourhostel_allow_ports" {
  vpc_id      = var.vpc_id
  description = "Allows access from any location to the specified ports"

  tags = {
    Name = "yourhostel-open-ports"
  }
}

resource "aws_security_group_rule" "yourhostel_ingress_rules" {
  count                    = length(var.open_ports)
  type                     = "ingress"
  from_port                = var.open_ports[count.index]
  to_port                  = var.open_ports[count.index]
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.yourhostel_allow_ports.id
}

resource "aws_security_group_rule" "yourhostel_egress_rules" {
  count                    = length(var.open_ports)
  type                     = "egress"
  from_port                = var.open_ports[count.index]
  to_port                  = var.open_ports[count.index]
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.yourhostel_allow_ports.id
}



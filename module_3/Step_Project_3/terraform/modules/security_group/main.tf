# Step_Project_3/terraform/modules/security_group/main.tf

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.prometheus_port
    to_port     = var.prometheus_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.grafana_port
    to_port     = var.grafana_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.node_exporter_port
    to_port     = var.node_exporter_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.cadvisor_port
    to_port     = var.cadvisor_port
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
    Name      = "${var.name}-sg"
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }
}






# Step_Project_3/terraform/modules/load_balancer/main.tf

resource "aws_elb" "this" {
  name               = "${var.name}-lb"
  availability_zones = var.azs
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = var.instance_ids

  tags = {
    Name       = "${var.name}-lb"
    Owner      = var.name
    CreatedBy  = var.name
    Purpose    = "step3"
  }
}






# Step_Project_3/terraform/main.tf

module "vpc" {
  source = "./modules/vpc"
  name   = var.name

  vpc_cidr            = var.vpc_cidr
  vpc_azs             = var.vpc_azs
  vpc_private_subnets = var.vpc_private_subnets
  vpc_public_subnets  = var.vpc_public_subnets
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
}

module "security_group" {
  source           = "./modules/security_group"
  name             = var.name
  vpc_id           = module.vpc.vpc_id
  prometheus_port  = var.prometheus_port
  grafana_port     = var.grafana_port
  node_exporter_port = var.node_exporter_port
  cadvisor_port    = var.cadvisor_port
}

module "ec2" {
  source          = "./modules/ec2"
  name            = var.name
  instance_count  = var.instance_count
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_ids      = module.vpc.public_subnets
  security_group_id = module.security_group.security_group_id
  ansible_user    = var.ansible_user
  private_key     = var.private_key
}

resource "aws_lb" "this" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security_group.security_group_id]
  subnets            = module.vpc.public_subnets

  tags = {
    Name      = "${var.name}-lb"
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name      = "${var.name}-tg"
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = element(module.ec2.instance_ids, 0)
  port             = 80
}

resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/inventory.tpl", {
    public_ips      = module.ec2.public_ips
    ansible_user    = var.ansible_user
    ansible_port    = var.ansible_port
    private_key     = var.private_key
    prometheus_port = var.prometheus_port
    grafana_port    = var.grafana_port
    node_exporter_port = var.node_exporter_port
    cadvisor_port   = var.cadvisor_port
  })
  filename = "${path.module}/../ansible/inventory"
}





























#module "vpc" {
#  source = "./modules/vpc"
#  name   = var.name
#}
#
#module "security_group" {
#  source  = "./modules/security_group"
#  name    = var.name
#  vpc_id  = module.vpc.vpc_id
#  open_ports = var.open_ports
#}
#
#module "ec2" {
#  source                 = "./modules/ec2"
#  name                   = var.name
#  ami                    = var.ami
#  instance_type          = var.instance_type
#  key_name               = var.key_name
#  subnet_id              = module.vpc.public_subnet_id
#  security_group_id      = module.security_group.security_group_id
#  instance_count         = var.instance_count
#}
#
#resource "local_file" "inventory" {
#  content = templatefile("${path.module}/inventory.tpl", {
#    instances = module.ec2.public_ips,
#    instance_ids = module.ec2.instances,
#    prometheus_port = var.prometheus_port,
#    grafana_port = var.grafana_port,
#    node_exporter_port = var.node_exporter_port,
#    cadvisor_port = var.cadvisor_port,
#    name = var.name,
#    open_ports = var.open_ports
#  })
#  filename = "${path.module}/../ansible/inventory.ini"
#}

#resource "null_resource" "wait_for_instances" {
#  provisioner "local-exec" {
#    command = <<EOT
#for ip in ${join(" ", module.ec2.public_ips)}; do
#  for i in {1..10}; do
#    nc -zv $ip 22 && break
#    sleep 5
#  done
#done
#EOT
#  }
#
#  triggers = {
#    instance_ids = join(",", module.ec2.instances)
#  }
#}
#
#resource "null_resource" "generate_ansible_hash" {
#  provisioner "local-exec" {
#    command = <<EOT
#find ../ansible -type f -exec sha256sum {} \; | sort -k 2 | sha256sum > ../ansible/ansible_hash.txt
#EOT
#  }
#
#  triggers = {
#    always_run = timestamp()
#  }
#}
#
#resource "null_resource" "run_ansible" {
#  provisioner "local-exec" {
#    command = "ANSIBLE_CONFIG=${path.module}/../ansible/ansible.cfg ansible-playbook ${path.module}/../ansible/playbooks/deploy.yml"
#  }
#
#  depends_on = [
#    null_resource.wait_for_instances,
#    null_resource.generate_ansible_hash
#  ]
#
#  triggers = {
#    instance_ids       = join(",", module.ec2.instances)
#    prometheus_port    = var.prometheus_port
#    grafana_port       = var.grafana_port
#    node_exporter_port = var.node_exporter_port
#    cadvisor_port      = var.cadvisor_port
#    open_ports         = join(",", var.open_ports)
#    ansible_hash       = timestamp()
#  }
#}
# homework-ansible-1/terraform/main.tf

module "vpc" {
  source = "./modules/vpc"
  name   = var.name
}

module "security_group" {
  source  = "./modules/security_group"
  name    = var.name
  vpc_id  = module.vpc.vpc_id
  open_ports = concat([var.nginx_port], var.open_ports)
}

module "ec2" {
  source                 = "./modules/ec2"
  name                   = var.name
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = module.vpc.public_subnet_id
  security_group_id      = module.security_group.security_group_id
  instance_count         = var.instance_count
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    instances = module.ec2.public_ips,
    nginx_port = var.nginx_port,
    name = var.name
  })
  filename = "${path.module}/../ansible/inventory.ini"
}

resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=${path.module}/../ansible/ansible.cfg ansible-playbook ${path.module}/../ansible/playbooks/deploy.yml"
  }

  triggers = {
    instance_ids = join(",", module.ec2.instances)
  }
}
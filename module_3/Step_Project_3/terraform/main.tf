# Step_Project_3/terraform/main.tf

module "vpc" {
  source  = "./modules/vpc"
  name    = var.name
  cidr    = var.vpc_cidr
  azs     = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
}

module "security_group" {
  source = "./modules/security_group"
  name   = var.name
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source              = "./modules/ec2"
  name                = var.name
  instance_count      = var.instance_count
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_ids          = module.vpc.public_subnets
  ansible_user        = var.ansible_user
  ansible_port        = var.ansible_port
  private_key         = var.private_key
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  security_group_id   = module.security_group.security_group_id
  instance_ids        = [module.ec2.instance_ids[0]]
}

resource "null_resource" "cleanup_inventory" {
  provisioner "local-exec" {
    command = "rm -f ../ansible/inventory.ini"
  }
}

resource "local_file" "inventory" {
  depends_on = [null_resource.cleanup_inventory]

  content = templatefile("${path.module}/inventory.tpl", {
    public_ips       = module.ec2.public_ips,
    ansible_user     = var.ansible_user,
    ansible_port     = var.ansible_port,
    private_key      = var.private_key,
    prometheus_port  = var.prometheus_port,
    grafana_port     = var.grafana_port,
    node_exporter_port = var.node_exporter_port,
    cadvisor_port    = var.cadvisor_port
  })
  filename = "${path.module}/../ansible/inventory.ini"
}

resource "null_resource" "ansible_playbook" {
  depends_on = [
    module.ec2,
    local_file.inventory
  ]

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/playbooks/deploy.yml"
  }
}

output "inventory" {
  value = templatefile("inventory.tpl", {
    public_ips       = module.ec2.public_ips,
    ansible_user     = var.ansible_user,
    ansible_port     = var.ansible_port,
    private_key      = var.private_key,
    prometheus_port  = var.prometheus_port,
    grafana_port     = var.grafana_port,
    node_exporter_port = var.node_exporter_port,
    cadvisor_port    = var.cadvisor_port
  })
}






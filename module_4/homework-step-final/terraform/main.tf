# terraform/main.tf

module "cluster" {
  source = "./modules/cluster"
  region        = var.region
  name          = var.name
  prefix        = var.prefix
  vpc_id        = var.vpc_id
  subnets_ids   = var.subnets_ids
  tags          = var.tags
}

module "ingress" {
  source = "./modules/ingress"
  depends_on = [module.cluster]

  name                   = var.name
  cluster_endpoint       = module.cluster.endpoint
  cluster_ca_certificate = module.cluster.cluster_ca_certificate
  cluster_token          = module.cluster.cluster_token
  prefix                 = var.prefix
}

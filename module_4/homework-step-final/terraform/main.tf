# terraform/main.tf

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.cluster.endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
  token                  = module.cluster.cluster_token
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.endpoint
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
    token                  = module.cluster.cluster_token
  }
}

module "cluster" {
  source      = "./modules/cluster"
  region      = var.region
  name        = var.name
  prefix      = var.prefix
  vpc_id      = var.vpc_id
  subnets_ids = var.subnets_ids
  tags        = var.tags
}

module "ingress" {
  source = "./modules/ingress"
  depends_on = [module.cluster]

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  name   = var.name
  prefix = var.prefix
}

output "eks_cluster_id" {
  value = module.cluster.eks_cluster_id
}

output "eks_node_group_id" {
  value = module.cluster.eks_node_group_id
}

output "eks_cluster_endpoint" {
  value = module.cluster.eks_cluster_endpoint
}

output "eks_cluster_security_group_id" {
  value = module.cluster.eks_cluster_security_group_id
}

output "nginx_ingress_release_status" {
  value = module.ingress.nginx_ingress_release_status
}

output "ingress_nginx_controller" {
  value = module.ingress.ingress_nginx_controller
}

# Output of nginx_ingress_service object for debugging
#output "nginx_ingress_service_full" {
#  value = module.ingress.nginx_ingress_service_full
#}
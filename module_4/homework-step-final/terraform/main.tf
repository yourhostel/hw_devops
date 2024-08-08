# terraform/main.tf

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.cluster.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
  token                  = module.cluster.cluster_token
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
    token                  = module.cluster.cluster_token
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "cluster" {
  source      = "./modules/cluster"

  region      = var.region
  name        = var.name
  prefix      = var.prefix
  vpc_id      = module.vpc.vpc_id
  subnets_ids = module.vpc.public_subnet_ids
  tags        = var.tags
}

module "cert_manager" {
  source = "./modules/cert_manager"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

module "issuer" {
  source = "./modules/issuer"
  depends_on = [module.cert_manager]

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

module "argo_cd" {
  source = "./modules/argo_cd"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
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

# Inside module, a script is used to install DNS records in a domain
# that is served by the hosting provider ukraine.com.ua
module "dns_updater" {
  source = "./modules/dns_updater"
  depends_on = [module.ingress]

  auth_token     = var.auth_token
  url_update_dns = var.url_update_dns

  # Used as a priority ALIAS record for the domain.
  subdomain_alias_id = var.subdomain_alias_id
  subdomain_alias = module.ingress.lb_hostname
  # If the ALIAS record is missing, all dns_record_ids will be set as type A records.
  dns_record_ids  = var.dns_record_ids
  dns_record_ips = module.ingress.load_balancer_ips
}

output "response_update_dns" {
  value = module.dns_updater.response_update_dns
}

output "load_balancer_ips" {
  value = module.ingress.load_balancer_ips
}

output "vpc" {
  value = {
  vpc_id      = module.vpc.vpc_id
  subnets_ids = module.vpc.public_subnet_ids
  }
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

output "argo_cd_admin_password" {
  description = "Initial admin password for Argo CD"
  value     = module.argo_cd.argo_cd_initial_admin_password
  sensitive = true
}

# Output of nginx_ingress_service object for debugging
#output "nginx_ingress_service_full" {
#  value = module.ingress.nginx_ingress_service_full
#}
# terraform/modules/ingress/main.tf

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Helm release for NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name       = "${var.prefix}-nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.3"

  set {
    name  = "controller.replicaCount"
    value = "1"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "http"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
  set {
    name  = "controller.service.targetPorts.http"
    value = "http"
  }
  set {
    name  = "controller.service.targetPorts.https"
    value = "https"
  }
  set {
    name  = "controller.allowSnippetAnnotations"
    value = "true"
  }
}

data "kubernetes_service" "nginx_ingress_service" {
  metadata {
    name      = "${var.prefix}-nginx-ingress-ingress-nginx-controller"
    namespace = "kube-system"
  }
}

data "aws_network_interfaces" "elb_interfaces" {
  filter {
    name   = "description"
    values = ["ELB ${data.kubernetes_service.nginx_ingress_service.status.0.load_balancer.0.ingress[0].hostname}*"]
  }
}

locals {
  elb_interface_ids = data.aws_network_interfaces.elb_interfaces.ids
}

data "aws_network_interface" "elb_interface" {
  for_each = toset(local.elb_interface_ids)
  id       = each.key
}

# Outputs
output "load_balancer_ips" {
  description = "Public IPs associated with the Load Balancer"
  value       = [for ni in data.aws_network_interfaces.elb_interfaces.ids : lookup(data.aws_network_interface.elb_interface[ni], "association", {})["public_ip"]]
}

output "nginx_ingress_release_status" {
  description = "Status of the NGINX Ingress Controller release"
  value       = helm_release.nginx_ingress.status
}

output "ingress_nginx_controller" {
  description = "Details of the NGINX Ingress Controller service"
  value = {
    type           = try(data.kubernetes_service.nginx_ingress_service.spec.0.type, "No type found")
    cluster_ip     = try(data.kubernetes_service.nginx_ingress_service.spec.0.cluster_ip, "No cluster IP found")
    external_ip    = try(data.kubernetes_service.nginx_ingress_service.status.0.load_balancer.0.ingress[0].hostname, "No external IP found")
    http           = try(data.kubernetes_service.nginx_ingress_service.spec.0.port[0].port, "No HTTP port found")
    https          = try(data.kubernetes_service.nginx_ingress_service.spec.0.port[1].port, "No HTTPS port found")
    node_port_http = try(data.kubernetes_service.nginx_ingress_service.spec.0.port[0].node_port, "No HTTP node port found")
    node_port_https= try(data.kubernetes_service.nginx_ingress_service.spec.0.port[1].node_port, "No HTTPS node port found")
  }
}

# Output of nginx_ingress_service object for debugging
#output "nginx_ingress_service_full" {
#  description = "Full data of the NGINX Ingress Service"
#  value       = data.kubernetes_service.nginx_ingress_service
#}
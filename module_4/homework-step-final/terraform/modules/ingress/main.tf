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

resource "time_sleep" "wait_10_seconds" {
  create_duration   = "10s"

  depends_on = [
    helm_release.nginx_ingress
  ]
}

data "kubernetes_service" "nginx_ingress_service" {
  metadata {
    name      = "${var.prefix}-nginx-ingress-controller"
    namespace = "kube-system"
  }

  depends_on = [
    time_sleep.wait_10_seconds
  ]
}

# Outputs
output "nginx_ingress_release_status" {
  description = "Status of the NGINX Ingress Controller release"
  value       = helm_release.nginx_ingress.status
}

output "nginx_ingress_hostname" {
  description = "External hostname for the NGINX Ingress Controller"
  value       = try(data.kubernetes_service.nginx_ingress_service.status.0.load_balancer.0.ingress.0.hostname, "No external hostname found")
}
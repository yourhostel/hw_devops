# terraform/modules/argo_cd/main.tf

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

resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.10.8"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = "final.tyshchenko.online/argo"
  }

  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target"
    value = "/$1"
  }

  set {
    name  = "server.ingress.annotations.kubernetes\\.io/ingress.class"
    value = "nginx"
  }
}

# Fetch the initial admin password for Argo CD
data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

output "argo_cd_initial_admin_password" {
  value = data.kubernetes_secret.argocd_initial_admin_secret.data["password"]
  sensitive = true
}

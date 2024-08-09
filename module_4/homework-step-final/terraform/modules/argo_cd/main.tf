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
  create_namespace = true

  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.34.2"

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
}

data "kubernetes_secret" "argocd_initial_admin_secret" {
  depends_on = [helm_release.argo_cd]

  metadata {
    name = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

output "argo_cd_admin_password" {
  value = data.kubernetes_secret.argocd_initial_admin_secret.data.password
  sensitive = true
}
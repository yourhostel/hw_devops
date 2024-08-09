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

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argo-cd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.10.8"

  values = [
    <<-EOF
    server:
      service:
        type: ClusterIP
    ingress:
      enabled: true
      ingressClassName: nginx
      hosts:
        - host: final.tyshchenko.online
          paths:
            - path: /argo
              pathType: ImplementationSpecific
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /$1
    EOF
  ]
}



# Fetch the initial admin password for Argo CD
data "kubernetes_secret" "argocd_initial_admin_secret" {
  depends_on = [helm_release.argo_cd]

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

output "argo_cd_initial_admin_password" {
  value = data.kubernetes_secret.argocd_initial_admin_secret.data["password"]
  sensitive = true
}

# terraform/modules/argo_application/main.tf

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

resource "null_resource" "argocd_ready_check" {
  triggers = {
    argocd_ready = var.argocd_ready ? "ready" : "not_ready"
  }
}

resource "kubernetes_manifest" "cert_manager" {
  depends_on = [
    null_resource.argocd_ready_check
  ]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "cert-manager"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://charts.jetstack.io"
        chart          = "cert-manager"
        targetRevision = "v1.15.0"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "cert-manager"
      }
      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
      }
    }
  }
}


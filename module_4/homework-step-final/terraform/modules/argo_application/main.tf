# terraform/modules/argo_application/main.tf

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

resource "null_resource" "argocd_ready_check" {
  count = var.argocd_ready ? 1 : 0
}


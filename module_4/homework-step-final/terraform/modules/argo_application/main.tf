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

resource "kubernetes_manifest" "nginx_ingress" {
  depends_on = [
    null_resource.argocd_ready_check
  ]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "nginx-ingress"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://kubernetes.github.io/ingress-nginx"
        chart          = "ingress-nginx"
        targetRevision = "4.0.3"
        helm = {
          parameters = [
            { name = "controller.replicaCount", value = "1" },
            { name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol", value = "https" },
            { name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme", value = "internet-facing" },
            { name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type", value = "nlb" },
            { name = "controller.service.targetPorts.http", value = "http" },
            { name = "controller.service.targetPorts.https", value = "https" },
            { name = "controller.allowSnippetAnnotations", value = "true" },
            { name = "controller.config.ssl-redirect", value = "false" },
            { name = "controller.config.force-ssl-redirect", value = "false" },
            { name = "controller.config.use-forwarded-headers", value = "true" }
          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "kube-system"
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

resource "kubernetes_manifest" "static_site" {
  depends_on = [
    null_resource.argocd_ready_check
  ]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "static-site"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/yourhostel/hw_devops"
        path           = "module_4/homework-step-final/helm_charts/static-site"
        targetRevision = "main"
        helm = {
          valueFiles = ["values.yaml"]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

resource "kubernetes_manifest" "python_app" {
  depends_on = [
    null_resource.argocd_ready_check
  ]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "python-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/yourhostel/hw_devops"
        path           = "module_4/homework-step-final/helm_charts/python-app"
        targetRevision = "main"
        helm = {
          valueFiles = ["values.yaml"]
          parameters = [
            { name = "image.repository", value = "yourhostel/devops-final" },
            { name = "namespace", value = "python-app" }
          ]
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "python-app"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

resource "kubernetes_manifest" "sealed_secret" {
  depends_on = [
    null_resource.argocd_ready_check
  ]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "sealed-secret"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/yourhostel/hw_devops"
        path           = "module_4/homework-step-final/sealed-secrets"
        targetRevision = "main"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "python-app"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

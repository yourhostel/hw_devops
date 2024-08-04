# terraform/modules/cert_manager/main.tf

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

# Installing Cert Manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.5.3"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# Using specialized Kubernetes provider resources
resource "kubernetes_cluster_role_binding" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cert-manager"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "cert-manager"
    namespace = "cert-manager"
  }
}

resource "kubernetes_custom_resource" "cluster_issuer" {
  api_version = "cert-manager.io/v1"
  kind        = "ClusterIssuer"
  metadata {
    name = "letsencrypt-prod"
  }

  spec = {
    acme {
      server = "https://acme-v02.api.letsencrypt.org/directory"
      email  = "youremail@example.com"
      private_key_secret_ref {
        name = "letsencrypt-prod"
      }
      solvers = [{
        http01 = {
          ingress = {
            class = "nginx"
          }
        }
      }]
    }
  }
  depends_on = [helm_release.cert_manager]
}





# terraform/modules/issuer/main.tf

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

resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata   = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "youremail@example.com"
        privateKeySecretRef = {
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
  }
}

resource "kubernetes_ingress" "https_ingress" {
  depends_on = [
    kubernetes_manifest.cluster_issuer
  ]
  metadata {
    name      = "https-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }

  spec {
    rule {
      host = "final.tyshchenko.online"
      http {
        path {
          path = "/argo"
          backend {
            service_name = "argo-service"
            service_port = 80
          }
        }
        path {
          path = "/python-app"
          backend {
            service_name = "python-app-service"
            service_port = 80
          }
        }
        path {
          path = "/"
          backend {
            service_name = "frontend-service"
            service_port = 80
          }
        }
      }
    }

    tls {
      hosts      = ["final.tyshchenko.online"]
      secret_name = "final-tyshchenko-online-tls"
    }
  }
}






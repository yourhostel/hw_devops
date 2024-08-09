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
        email  = "yourhostel.ua@gmail.com"
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

resource "kubernetes_manifest" "https_ingress" {
  depends_on = [
    kubernetes_manifest.cluster_issuer
  ]

  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "https-ingress"
      namespace = "argocd"
      annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
        "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
        "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
      }
    }
    spec = {
      rules = [
        {
          host = "final.tyshchenko.online"
          http = {
            paths = [
              {
                path = "/argo"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = "argo-cd-argocd-server"
                    port = {
                      number = 443
                    }
                  }
                }
              },
              {
                path = "/python-app"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = "python-app-service"
                    port = {
                      number = 80
                    }
                  }
                }
              },
              {
                path = "/"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = "frontend-service"
                    port = {
                      number = 80
                    }
                  }
                }
              }
            ]
          }
        }
      ]
      tls = [
        {
          hosts = ["final.tyshchenko.online"]
          secretName = "final-tyshchenko-online-tls"
        }
      ]
    }
  }
}



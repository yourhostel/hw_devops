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
  version    = "v1.15.0"
}

resource "null_resource" "install_crds" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.crds.yaml
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}


resource "kubernetes_manifest" "cluster_issuer" {
  depends_on = [helm_release.cert_manager, null_resource.install_crds]

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






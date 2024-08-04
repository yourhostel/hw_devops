# terraform/modules/cert_manager/main.tf

#terraform {
#  required_providers {
#    kubernetes = {
#      source  = "hashicorp/kubernetes"
#      version = "~> 2.0"
#    }
#    helm = {
#      source  = "hashicorp/helm"
#      version = "~> 2.0"
#    }
#  }
#}

provider "kubernetes" {
  host                   = var.kube_host
  cluster_ca_certificate = var.cluster_ca_certificate
  token                  = var.kube_token
}

provider "helm" {
  kubernetes {
    host                   = var.kube_host
    cluster_ca_certificate = var.cluster_ca_certificate
    token                  = var.kube_token
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

# Creating ClusterIssuer
resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata   = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server          = "https://acme-v02.api.letsencrypt.org/directory"
        email           = "	yourhostel.ua@gmail.com"
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

# Requesting a certificate for the domain final.tyshchenko.online
resource "kubernetes_manifest" "certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata   = {
      name      = "final-tyshchenko-online"
      namespace = "cert-manager"
    }
    spec = {
      secretName = "final-tyshchenko-online-tls"
      issuerRef = {
        name = "letsencrypt-prod"
        kind = "ClusterIssuer"
      }
      dnsNames = ["final.tyshchenko.online"]
    }
  }
}


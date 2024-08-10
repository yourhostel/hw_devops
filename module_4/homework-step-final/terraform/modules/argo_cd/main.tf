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

  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.34.2"

  # Sets the service type of the Argo CD server to ClusterIP, making it accessible only within the cluster.
  set {
      name  = "server.service.type"
      value = "ClusterIP"
  }

  # Disables TLS for the Argo CD server, allowing it to serve traffic over HTTP.
  set {
      name  = "server.extraArgs[0]"
      value = "--insecure"
  }

  # Sets the root path for the Argo CD server, allowing it to be accessed at /argo.
  set {
      name  = "server.extraArgs[1]"
      value = "--rootpath=/argo"
  }

  # Disables TLS for the Argo CD repository server, ensuring that it serves traffic over HTTP.
  set {
      name  = "repoServer.extraArgs[0]"
      value = "--disable-tls"
  }

  # Disables TLS for the Argo CD Dex server, ensuring that it serves traffic over HTTP.
  set {
      name  = "dexServer.extraArgs[0]"
      value = "--disable-tls"
  }
}

resource "null_resource" "argocd_ready_check" {
  provisioner "local-exec" {
    command = "kubectl get deploy argo-cd-argocd-server -n argocd -o jsonpath='{.status.availableReplicas}' | grep '1'"
  }

  depends_on = [helm_release.argo_cd]
}

output "argocd_ready" {
  value     = null_resource.argocd_ready_check.id != "" ? true : false
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
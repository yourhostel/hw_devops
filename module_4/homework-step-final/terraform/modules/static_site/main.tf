# terraform/modules/static_site/main.tf

resource "helm_release" "static_site" {
  name       = "static-site"
  namespace  = "argocd"
  repository = "https://github.com/yourhostel/hw_devops"
  chart      = "module_4/homework-step-final/helm_charts/static-site"
  version    = "main"

  set {
    name  = "title"
    value = "Welcome to final.tyshchenko.online"
  }

  set {
    name  = "message"
    value = "This is a static site served by Nginx"
  }

  set {
    name  = "replicas"
    value = 1
  }

  set {
    name  = "nginx.tag"
    value = "latest"
  }
}

# terraform/modules/python_app/main.tf

resource "helm_release" "python_app" {
  name       = "python-app"
  namespace  = "python-app"
  chart      = "../helm_charts/python-app"

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "image.repository"
    value = "yourhostel/devops-final"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "namespace"
    value = "python-app"
  }
}
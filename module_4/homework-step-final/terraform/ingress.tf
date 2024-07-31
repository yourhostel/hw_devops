# terraform/ingress.tf

# Helm release for NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name       = "${var.prefix}-nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.3"

  set {
    name  = "controller.replicaCount"
    value = "1"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "http"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
  set {
    name  = "controller.service.targetPorts.http"
    value = "http"
  }
  set {
    name  = "controller.service.targetPorts.https"
    value = "https"
  }
  set {
    name  = "controller.allowSnippetAnnotations"
    value = "true"
  }
}

output "nginx_ingress_release_status" {
  description = "Status of the NGINX Ingress Controller release"
  value       = helm_release.nginx_ingress.status
}

# Kubernetes provider configuration
data "aws_eks_cluster" "eks_cluster_data" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster_data.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_data.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster_data.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_data.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}

data "kubernetes_service" "nginx_ingress_service" {
  metadata {
    name      = "${var.prefix}-nginx-ingress-ingress-nginx-controller"
    namespace = "kube-system"
  }
}

output "nginx_ingress_hostname" {
  description = "Hostname of the NGINX Ingress Controller"
  value       = data.kubernetes_service.nginx_ingress_service.status[0].load_balancer[0].ingress[0].hostname
}
# terraform/modules/ingress/main.tf

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

resource "kubernetes_ingress" "https_ingress" {
  depends_on = [
    helm_release.nginx_ingress
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

data "kubernetes_service" "nginx_ingress_service" {
    depends_on = [
    helm_release.nginx_ingress
  ]

  metadata {
    name      = "${var.prefix}-nginx-ingress-ingress-nginx-controller"
    namespace = "kube-system"
  }
}

locals {
  lb_hostname = data.kubernetes_service.nginx_ingress_service.status.0.load_balancer.0.ingress[0].hostname
}

locals {
  service_spec = data.kubernetes_service.nginx_ingress_service.spec[0]
}

resource "null_resource" "fetch_elb_ips" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
     aws ec2 describe-network-interfaces \
     --filters "Name=description,Values='ELB net/$(echo ${local.lb_hostname} | cut -d'-' -f1)*'" \
     --query 'NetworkInterfaces[*].Association.PublicIp' \
     --output json > /tmp/elb_ips.json
    EOT
  }
}

data "local_file" "elb_ips" {
  filename   = "/tmp/elb_ips.json"
  depends_on = [null_resource.fetch_elb_ips]
}

# Outputs
output "lb_hostname" {
  description = "External IP is used as an alias to set up a DNS record"
  value = local.lb_hostname
}

output "load_balancer_ips" {
  description = "Public IPs associated with the Load Balancer"
  value       = jsondecode(data.local_file.elb_ips.content)
}

output "nginx_ingress_release_status" {
  description = "Status of the NGINX Ingress Controller release"
  value       = helm_release.nginx_ingress.status
}

output "ingress_nginx_controller" {
  description = "Details of the NGINX Ingress Controller service"
  value = {
    type           = try(local.service_spec.type, "No type found")
    cluster_ip     = try(local.service_spec.cluster_ip, "No cluster IP found")
    external_ip    = try(local.lb_hostname, "No external IP found")
    http           = try(local.service_spec.port[0].port, "No HTTP port found")
    https          = try(local.service_spec.port[1].port, "No HTTPS port found")
    node_port_http = try(local.service_spec.port[0].node_port, "No HTTP node port found")
    node_port_https= try(local.service_spec.port[1].node_port, "No HTTPS node port found")
  }
}

# Output of nginx_ingress_service object for debugging
#output "nginx_ingress_service_full" {
#  description = "Full data of the NGINX Ingress Service"
#  value       = data.kubernetes_service.nginx_ingress_service
#}
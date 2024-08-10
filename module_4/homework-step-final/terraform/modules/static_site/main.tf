# terraform/modules/static_site/main.tf

resource "kubernetes_config_map" "nginx_html" {
  metadata {
    name      = "nginx-html"
    namespace = "default"
  }

  data = {
    "index.html" = <<-EOF
<html>
<head><title>Welcome</title></head>
<body>
<h1>Welcome to final.tyshchenko.online</h1>
</body>
</html>
EOF
  }
}

resource "kubernetes_deployment" "static_site" {
  metadata {
    name      = "static_site"
    namespace = "default"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "static_site"
      }
    }

    template {
      metadata {
        labels = {
          app = "static-site"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }

          volume_mount {
            name       = "html-volume"
            mount_path = "/usr/share/nginx/html"
            read_only  = true
          }
        }

        volume {
          name = "html-volume"

          config_map {
            name = kubernetes_config_map.nginx_html.metadata[0].name
            items {
              key  = "index.html"
              path = "index.html"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "static_site" {
  metadata {
    name      = "static-site-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "static-site"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

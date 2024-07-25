auto_auth {
  method "kubernetes" {
    mount_path = "auth/kubernetes"
    config = {
      role = "your-role"
    }
  }
}

template {
  destination = "/etc/secrets/db-creds"
  content = <<EOH
  {{ with secret "secret/data/postgresql/admin" }}
  export DB_USERNAME={{ .Data.data.username }}
  export DB_PASSWORD={{ .Data.data.password }}
  {{ end }}
  EOH
}

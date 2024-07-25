auto_auth {
  method "kubernetes" {
    mount_path = "auth/kubernetes"
    config = {
      role = "yourhostel-role"
    }
  }
}

template {
  source = "secret/data/postgresql/admin"
  destination = "/etc/secrets/db-creds"
  command = "export DB_USERNAME={{ .Data.data.username }}\nexport DB_PASSWORD={{ .Data.data.password }}"
}

vault {
  address = "http://127.0.0.1:8200"
}

log_level = "debug"




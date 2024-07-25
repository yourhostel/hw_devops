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

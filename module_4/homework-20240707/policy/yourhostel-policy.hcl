path "auth/kubernetes/login" {
  capabilities = ["create", "update", "read"]
}

path "secret/data/*" {
  capabilities = ["read"]
}

path "auth/token/create" {
  capabilities = ["update"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}
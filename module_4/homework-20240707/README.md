# Vault

[homework-20240707](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240707.md)

* Creating a Cluster Using Kind and [kind-config.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240707/kind-config.yaml)
```bash
# Deleting the current cluster
kind delete cluster --name yourhostel-cluster
# Creating a new cluster
kind create cluster --config kind-config.yaml --name yourhostel-cluster
```
![vault (1).jpg](screenshots%2Fvault%20%281%29.jpg)

* Using Helm to Install Argo SD in Kubernetes Cluster
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argo-cd argo/argo-cd -n argocd --create-namespace
# Run the pod for testing if necessary
kubectl run curl-pod --image=radial/busyboxplus:curl -i --tty --rm
# Inside the pod check that the Argo CD is working
curl -k https://argo-cd-argocd-server.argocd:443
```
![vault (2).jpg](screenshots%2Fvault%20%282%29.jpg)

* Access to pods inside the cluster from outside using a [argo-cd-service-nodeport.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240707/argo-cd-service-nodeport.yaml)
```bash
kubectl apply -f argo-cd-service-nodeport.yaml
```

![vault (3).jpg](screenshots%2Fvault%20%283%29.jpg)
```bash
# Install CLI for Argo CD
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v2.11.7/argocd-linux-amd64
chmod +x argocd-linux-amd64
# For the ability to run from anywhere in the system
sudo mv argocd-linux-amd64 /usr/local/bin/argocd 
argocd login <ARGO_CD_SERVER> # my server 192.168.88.244:31500
# *** Enter Username
# *** Enter Password

# Update password
argocd account update-password
# *** Enter current password: 
# *** Enter new password: 
# *** Confirm new password: 
```
* Extracting and decoding the initial administrator password for Argo CD
```bash
# Get password for admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

argocd login 192.168.88.244:31500
```
![vault (4).jpg](screenshots%2Fvault%20%284%29.jpg)
![vault (5).jpg](screenshots%2Fvault%20%285%29.jpg)

* Integrate vault with Argo CD using configuration [argo-project.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240707/argo-project.yaml) and [vault-dev.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240707/vault-dev.yaml) so that its deployment and configuration can be managed through the Argo CD interface and CLI.
```bash
kubectl apply -f argo-project.yaml

kubectl create namespace vault
kubectl apply -f vault-dev.yaml
argocd app sync vault
```
![vault (6).jpg](screenshots%2Fvault%20%286%29.jpg)
![vault (7).jpg](screenshots%2Fvault%20%287%29.jpg)

* Create a ServiceAccount named `yourhostel-user` in the `default` namespace
```bash
kubectl get pods -n vault

kubectl create serviceaccount yourhostel-user --namespace default  
kubectl get serviceaccount yourhostel-user -n default
```
![vault (8).jpg](screenshots%2Fvault%20%288%29.jpg)

* Configuring Vault to integrate with Kubernetes
```bash
kubectl exec -it vault-0 -n vault -- /bin/sh

# Creates a policy in Vault named postgresql-policy
vault policy write postgresql-policy - <<EOF
path "secret/*" {
  capabilities = ["read"]
}
EOF

# Enables Vault to use Kubernetes to authenticate users and applications
vault auth enable kubernetes

# Configures the Kubernetes authentication method in Vault
vault write auth/kubernetes/config \
  token_reviewer_jwt="$(kubectl get secret $(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)" \
  kubernetes_host="https://kubernetes.default.svc:443" \
  kubernetes_ca_cert="@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

# Creates a role for the Kubernetes authentication method in Vault named `yourhostel-role`
vault write auth/kubernetes/role/yourhostel-role \
    bound_service_account_names=yourhostel-user \
    bound_service_account_namespaces=default \
    policies=postgresql-policy \
    ttl=24h
```
![vault (9).jpg](screenshots%2Fvault%20%289%29.jpg)

* Create a secret
```bash
kubectl exec -it vault-0 -n vault -- vault kv put secret/postgresql/admin username="admin" password="1234"
kubectl exec -it vault-0 -n vault -- vault kv get secret/postgresql/admin
```
![vault (10).jpg](screenshots%2Fvault%20%2810%29.jpg)

# postgresql-variant-1
* Run [postgresql-variant-1/postgresql-statefulset.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240707/postgresql-variant-1/postgresql-statefulset.yaml). In this example, the database account is created based on the secrets of Vault automatically
```bash
kubectl apply -f postgresql-variant-1/postgresql-statefulset.yaml
kubectl get pods postgresql-0 -n default -o wide
```
![vault (11).jpg](screenshots%2Fvault%20%2811%29.jpg)

```bash
kubectl logs postgresql-0 -c vault-agent-init -n default
```
![vault (12).jpg](screenshots%2Fvault%20%2812%29.jpg)

* Checking automatic substitution of credentials `admin`
```bash
kubectl exec -it postgresql-0 -c postgres -- psql -U admin -d postgres
-- SELECT current_user;
-- \q
```
![vault (13).jpg](screenshots%2Fvault%20%2813%29.jpg)

* Change the secret and recreate the database to make sure the configuration works
```bash
kubectl exec -it vault-0 -n vault -- vault kv put secret/postgresql/admin username="yourhostel" password="52486"

kubectl delete statefulset postgresql -n default
kubectl delete pvc postgredb-postgresql-0 -n default
kubectl apply -f postgresql-variant-1/postgresql-statefulset.yaml

kubectl exec -it postgresql-0 -c postgres -- psql -U yourhostel -d postgres
```
![vault (14).jpg](screenshots%2Fvault%20%2814%29.jpg)

# postgresql-variant-2
* Run [postgresql-variant-2/postgresql-statefulset.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240707/postgresql-variant-2/postgresql-statefulset.yaml). Creates an account manually using the default user `postgres`. Specify the login and password that Vault stores. Verify that Vault substitutes the secret into the template string from the pgpass file and sets it to the PGPASSFILE environment variable.
```bash
kubectl apply -f postgresql-variant-2/postgresql-statefulset.yaml

kubectl get pods postgres-0 -n default -o wide
kubectl describe pod postgres-0 -n default
```
![vault (15).jpg](screenshots%2Fvault%20%2815%29.jpg)

* Use the default user `postgres` to create a new account in the database
```bash
kubectl exec -it postgres-0 -c postgres -- psql -U postgres
-- CREATE ROLE yourhostel WITH LOGIN PASSWORD '52486';
-- GRANT ALL PRIVILEGES ON DATABASE postgres TO yourhostel;
-- \q

kubectl delete pod postgres-0 -n default

# Use the created account to log in. Do not specify the password.
# The password is automatically substituted by Vault, the same secret that is used in variant-1
kubectl exec -it postgres-0 -c postgres -- psql -U yourhostel -d postgres
-- SELECT current_user;
-- \q
```
![vault (16).jpg](screenshots%2Fvault%20%2816%29.jpg)

* The command creates a new application in Argo CD based on the configuration file [postgresql-argo-application.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240707/postgresql-argo-application.yaml)` for both variants
```bash
sed 's/VAR/1/g' postgresql-argo-application.yaml | argocd app create -f -
sed 's/VAR/1/g' postgresql-argo-application.yaml | argocd app create -f -
```
![vault (17).jpg](screenshots%2Fvault%20%2817%29.jpg)

# Setting up dynamic secret generation for database variant-1
* The service provides network access to PostgreSQL pods
```bash
kubectl apply -f postgresql-variant-1/postgresql-service.yaml
```

* View and Copy PostgreSQL Configuration File
```bash
# outputs the contents of the pg_hba.conf file
kubectl exec -it postgresql-0 -c postgres -- cat /var/lib/postgresql/data/pgdata/pg_hba.conf

# copies pg_hba.conf file from the postgresql-0 pod to the local machine
kubectl cp default/postgresql-0:/var/lib/postgresql/data/pgdata/pg_hba.conf ./pg_hba.conf
ls
```
![vault (18).jpg](screenshots%2Fvault%20%2818%29.jpg)

* Adding the host all all 10.244.0.0/16 md5 rule ensures that all pods within the Kubernetes cluster can request and use credentials generated by Vault, requiring that they provide an MD5-hashed password for authentication.
```bash
nano pg_hba.conf
# kubectl get pods postgresql-0 -n default -o wide # check ip
# host    all             all             10.244.0.0/16          md5
```
![vault (19).jpg](screenshots%2Fvault%20%2819%29.jpg)

* Updating the pg_hba.conf file in the pod and restarting the pod
```bash
kubectl cp ./pg_hba.conf default/postgresql-0:/var/lib/postgresql/data/pgdata/pg_hba.conf
kubectl delete pod postgresql-0 -n default
```
![vault (20).jpg](screenshots%2Fvault%20%2820%29.jpg)

```bash
# Create a user for vault
kubectl exec -it postgresql-0 -c postgres -- psql -U yourhostel -d postgres
-- CREATE USER vaultadmin WITH PASSWORD 'strongvaultpassword';
-- ALTER USER vaultadmin WITH CREATEROLE;

# Only those rights necessary to manage dynamic secrets through Vault.
-- GRANT CREATE ON DATABASE postgres TO vaultadmin;
# or
# Super User (not recommended for testing only)
-- ALTER USER vaultadmin WITH SUPERUSER;

kubectl exec -it vault-0 -n vault -- /bin/sh
# This command enables the secret database engine in Vault.
# This is necessary so that Vault can manage credentials and database connections.
vault secrets enable database

# This command configures a connection to PostgreSQL using the database plugin.
vault write database/config/postgres \
  plugin_name=postgresql-database-plugin \
  allowed_roles="my-role" \
  connection_url="postgresql://{{username}}:{{password}}@postgresql.default.svc.cluster.local:5432/postgres?sslmode=disable" \
  username="vaultadmin" \
  password="strongvaultpassword"

# This command defines a role in Vault to create database user accounts using predefined SQL statements. 
vault write database/roles/my-role \
    db_name=postgres \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"  
   
# This command defines a role in Vault to create database user accounts using predefined SQL statements.   
vault read database/creds/my-role    
```
![vault (21).jpg](screenshots%2Fvault%20%2821%29.jpg)

```bash
kubectl exec -it postgresql-0 -c postgres -- psql -U v-token-my-role-HsTpqGn9y7VxcXYHr4lL-1722036023 -d postgres -h postgresql.default.svc.cluster.local -W
```
![vault (22).jpg](screenshots%2Fvault%20%2822%29.jpg)


*** Useful commands for debugging
```bash
kubectl delete statefulset postgresql -n default
kubectl delete pvc postgredb-postgresql-0 -n default
kubectl apply -f postgresql-variant-1/postgresql-statefulset.yaml
kubectl replace --force -f postgresql-variant-1/postgresql-statefulset.yaml
kubectl rollout restart statefulset postgresql -n default
kubectl get pods postgresql-0 -n default -o wide
kubectl logs postgresql-0 -c vault-agent-init -n default
kubectl describe pod postgresql-0 -n default
kubectl logs postgresql-0 -c postgres -n default
kubectl exec -it postgresql-0 -c postgres -- cat /var/lib/postgresql/data/pgdata/pg_hba.conf
```
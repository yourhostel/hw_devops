# Vault

[homework-20240707](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240707.md)

```bash
# Deleting the current Kind cluster:
kind delete cluster --name yourhostel-cluster
# Создание нового кластера Kind:
kind create cluster --config kind-config.yaml --name yourhostel-cluster

# CLI for Argo CD
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v2.11.7/argocd-linux-amd64
chmod +x argocd-linux-amd64
sudo mv argocd-linux-amd64 /usr/local/bin/argocd
argocd login <ARGO_CD_SERVER> # my server 192.168.88.244:31500
# *** Enter Username
# *** Enter Password

# Using helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argo-cd argo/argo-cd -n argocd --create-namespace

kubectl apply -f argo-cd-service-nodeport.yaml

# run the pod for testing if necessary
kubectl run curl-pod --image=radial/busyboxplus:curl -i --tty --rm
# inside the pod check that the Argo CD is working
curl -k https://argo-cd-argocd-server.argocd:443

# Get password for admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

argocd login 192.168.88.244:31500

# Update password
argocd account update-password
# *** Enter current password: 
# *** Enter new password: 
# *** Confirm new password: 
```

```bash
kubectl apply -f argo-project.yaml

kubectl create namespace vault
kubectl apply -f vault-dev.yaml
argocd app sync vault

```

```bash
# OpenSS for сгенерировать сертификат и ключ
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=vault-agent-injector-svc.vault.svc"
# Создать секрет с сертификатом и ключом
kubectl -n vault create secret tls vault-agent-injector-svc-tls --cert=cert.pem --key=key.pem
# перезапустить pod
kubectl -n vault rollout restart deployment/vault-agent-injector
# chek конфигурация MutatingWebhookConfiguration обновлена с новым сертификатом:
kubectl describe mutatingwebhookconfiguration vault-agent-injector-cfg
```
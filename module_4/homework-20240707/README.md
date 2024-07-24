# Vault

[homework-20240707](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240707.md)

```bash
# Deleting the current Kind cluster:
kind delete cluster --name yourhostel-cluster
# Создание нового кластера Kind:
kind create cluster --config kind-config.yaml --name yourhostel-cluster

# Option 1
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# or

# Option 2 using helm
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

# Update password
argocd account update-password
# *** Enter current password: 
# *** Enter new password: 
# *** Confirm new password: 
```
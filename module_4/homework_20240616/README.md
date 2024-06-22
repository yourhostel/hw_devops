# Kubernetes basics

 [homework-20240616](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240616.md)

This work uses the same [manifest for nginx](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework_20240616/nginx-deployment.yaml) as in the [homework_20240613](https://github.com/yourhostel/hw_devops/tree/main/module_4/homework_20240613), but instead of the 
```bash
kubectl port-forward pod/yourhostel-nginx-deployment-585449566-k5zmp 8090:80 --address 192.168.88.244
``` 
command, the cluster is configured using [kind-config.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework_20240616/kind-config.yaml) and the [nginx-service.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework_20240616/nginx-service.yaml) service is added to control traffic routing.
The port was also replaced from 8089 to 30007 and now a service of the NodePort type provides access to all pods corresponding to the `app=nginx` selector through the specified port `3007` on each cluster node.

### Network Diagram


```plaintext
Client (192.168.88.100:30007)
     |
     V
Node (192.168.88.244:30007) <--- Port Forwarding in Kind
     |
     V
Service (NodePort: 30007) <---> Pods (Nginx, port 80)

```
### Creating a cluster `yourhostel`
```bash
kind create cluster --name yourhostel --config kind-config.yaml
```
![hw_kub_2 (1).jpg](screenshots%2Fhw_kub_2%20%281%29.jpg)

### Applying the manifest nginx deploy
```bash
kubectl apply -f nginx-deployment.yaml
```
![hw_kub_2 (2).jpg](screenshots%2Fhw_kub_2%20%282%29.jpg)

### Applying the manifest nginx service type `NodePort`
```bash
kubectl apply -f nginx-service.yaml
```
![hw_kub_2 (3).jpg](screenshots%2Fhw_kub_2%20%283%29.jpg)

### Displays a list of pods labeled app=nginx
```bash
kubectl get pods -l app=nginx
```
### Displays a list of services in the cluster
- nginx-service is configured as NodePort with port 30007
```bash
kubectl get svc
```
![hw_kub_2 (4).jpg](screenshots%2Fhw_kub_2%20%284%29.jpg)

### The local network
![hw_kub_2 (5).jpg](screenshots%2Fhw_kub_2%20%285%29.jpg)

### Internet
![hw_kub_2 (6).jpg](screenshots%2Fhw_kub_2%20%286%29.jpg)
![hw_kub_2 (7).jpg](screenshots%2Fhw_kub_2%20%287%29.jpg)
# Kubernetes Deployment with PVC

[homework-20240620](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240620.md?ref_type=heads&plain=1)
```
homework-20240620
├── deployments
│ └── yourhostel-nginx-deployment.yaml
├── namespaces
│ └── namespace.yaml
├── screenshots
├── services
│ └── yourhostel-nginx-service.yaml
├── volumes
│ ├── busybox-pod.yaml
│ └── yourhostel-pvc.yaml
└── kustomization.yaml
```
### At the root of the project
```yaml
# homework-20240620/kustomization.yaml

resources:
  - namespaces/namespace.yaml
  - volumes/yourhostel-pvc.yaml
  - deployments/yourhostel-nginx-deployment.yaml
  - services/yourhostel-nginx-service.yaml
  - volumes/busybox-pod.yaml
```
```bash
kubectl apply -k .
```
![kub_3 (1).jpg](screenshots%2Fkub_3%20%281%29.jpg)
```bash
kubectl get namespaces
```
![kub_3 (2).jpg](screenshots%2Fkub_3%20%282%29.jpg)
```bash
kubectl get pvc -n yourhostel-namespace
```
![kub_3 (3).jpg](screenshots%2Fkub_3%20%283%29.jpg)
```bash
kubectl get deployment -n yourhostel-namespace
kubectl get pods -n yourhostel-namespace
```
![kub_3 (4).jpg](screenshots%2Fkub_3%20%284%29.jpg)
```bash
kubectl get svc -n yourhostel-namespace
```
![kub_3 (5).jpg](screenshots%2Fkub_3%20%285%29.jpg)

### Copying a test HTML file to PVC
```bash
kubectl exec -it busybox --namespace=yourhostel-namespace -- /bin/sh
```
![kub_3 (6).jpg](screenshots%2Fkub_3%20%286%29.jpg)
![kub_3 (7).jpg](screenshots%2Fkub_3%20%287%29.jpg)

### Delete pod busybox and verifying that nginx returns test HTML
```bash
kubectl delete pod busybox --namespace=yourhostel-namespace
```
![kub_3 (8).jpg](screenshots%2Fkub_3%20%288%29.jpg)
![kub_3 (9).jpg](screenshots%2Fkub_3%20%289%29.jpg)

### Removing Pod from nginx
![kub_3 (10).jpg](screenshots%2Fkub_3%20%2810%29.jpg)

###  Redirect to another port
![kub_3 (11).jpg](screenshots%2Fkub_3%20%2811%29.jpg)

###  Let's make sure everything works
![kub_3 (12).jpg](screenshots%2Fkub_3%20%2812%29.jpg)

### Deleting all created resources. busybox was deleted earlier so the deletion error occurred.
```bash
kubectl delete -k .
```
![kub_3 (13).jpg](screenshots%2Fkub_3%20%2813%29.jpg)
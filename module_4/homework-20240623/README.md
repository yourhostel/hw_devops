# Kubernetes Deploy App

[homework-20240623](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240623.md)
```
homework-20240623
├── deployments
│   └── yourhostel-python-deployment.yaml
├── docker
│   ├── Dockerfile
│   ├── requirements.txt
│   └── web_server.py
├── ingress
│   └── yourhostel-python-ingress.yaml
├── namespaces
│   └── namespace.yaml
├── services
│    └── yourhostel-python-service.yaml
└── kustomization.yaml
```
## Creating a docker image
![kub_4 (1).jpg](screenshots%2Fkub_4%20%281%29.jpg)

## docker send image to registry
![kub_4 (2).jpg](screenshots%2Fkub_4%20%282%29.jpg)
![kub_4 (3).jpg](screenshots%2Fkub_4%20%283%29.jpg)
![kub_4 (4).jpg](screenshots%2Fkub_4%20%284%29.jpg)

## Add a link to the created docker image in [yourhostel-python-deployment.yaml](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-20240623/deployments/yourhostel-python-deployment.yaml)
![kub_4 (5).jpg](screenshots%2Fkub_4%20%285%29.jpg)

## Preparing the helm
![kub_4 (6).jpg](screenshots%2Fkub_4%20%286%29.jpg)

## Install Nginx Ingress Controller
If the Ingress controller is not yet installed, run the command to install it. Using Helm to install Nginx Ingress Controller:
```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace default \
  --set controller.watchNamespace= \
  --set controller.ingressClass=nginx \
  --set controller.service.type=LoadBalancer \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.service.ports.http=80 \
  --set controller.service.ports.https=443 \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-scheme"=internet-facing
```

```yaml
helm install ingress-nginx ingress-nginx/ingress-nginx:
  - Installs the Helm chart ingress-nginx from the ingress-nginx repository under the name ingress-nginx.
--namespace default:
  - Installs the chart in the default namespace.
--set controller.watchNamespace=:
  - Leaves the controller.watchNamespace value empty, meaning the Ingress controller will watch all namespaces.
--set controller.ingressClass=nginx:
  - Sets the Ingress class to nginx, allowing the Ingress controller to handle only Ingress resources with the nginx class.
--set controller.service.type=LoadBalancer:
  - Sets the type of the controller's service to LoadBalancer, automatically creating a load balancer (e.g., AWS ELB).
--set controller.service.externalTrafficPolicy=Local:
  - Sets the external traffic policy to Local, directing external traffic directly to nodes where Ingress controller pods are running, bypassing additional routing.
--set controller.service.ports.http=80:
  - Specifies port 80 for HTTP traffic in the controller's service.
--set controller.service.ports.https=443:
  - Specifies port 443 for HTTPS traffic in the controller's service.
--set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-scheme"=internet-facing:
  - Adds an annotation to the service to make the AWS load balancer internet-facing, thus accessible from outside.

```
After installation, check the load balancer
![kub_4 (7).jpg](screenshots%2Fkub_4%20%287%29.jpg)

## Applying Kubernetes configuration
```bash
kubectl apply -k .
```
![kub_4 (8).jpg](screenshots%2Fkub_4%20%288%29.jpg)

## Checking the operation of endpoints in non-clusters

![kub_4 (9).jpg](screenshots%2Fkub_4%20%289%29.jpg)
![kub_4 (10).jpg](screenshots%2Fkub_4%20%2810%29.jpg)
![kub_4 (11).jpg](screenshots%2Fkub_4%20%2811%29.jpg)
![kub_4 (12).jpg](screenshots%2Fkub_4%20%2812%29.jpg)

## Deleting resources
```bash
helm uninstall ingress-nginx -n default
kubectl delete -k .
```
![kub_4 (13).jpg](screenshots%2Fkub_4%20%2813%29.jpg)
# Kubernetes basics

 [homework-20240613](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240613.md)

## Creating a cluster `yourhostel`
```bash
kind create cluster --name yourhostel
```
![hw_kub_1 (1).jpg](screenshots%2Fhw_kub_1%20%281%29.jpg)

## Applying the [manifest](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework_20240613/nginx-deployment.yaml) for `Nginx Deployment`
```bash
kubectl apply -f nginx-deployment.yaml
```
![hw_kub_1 (2).jpg](screenshots%2Fhw_kub_1%20%282%29.jpg)

## Getting Pods
get all pods or filter by application
```bash
kubectl get po
kubectl get pods -l app=nginx
```
![hw_kub_1 (3).jpg](screenshots%2Fhw_kub_1%20%283%29.jpg)

## Forwarding the port and address on the local network
```bash
kubectl port-forward pod/yourhostel-nginx-deployment-585449566-k5zmp 8090:80 --address 192.168.88.244
```
![hw_kub_1 (4).jpg](screenshots%2Fhw_kub_1%20%284%29.jpg)

## Сhecking on the local network
![hw_kub_1 (5).jpg](screenshots%2Fhw_kub_1%20%285%29.jpg)

## Throwing it into the world
![hw_kub_1 (6).jpg](screenshots%2Fhw_kub_1%20%286%29.jpg)

## Сhecking availability on the Internet
![hw_kub_1 (7).jpg](screenshots%2Fhw_kub_1%20%287%29.jpg)

## Connect to the pod and change index.html for nginx
```bash
kubectl exec -it pod/yourhostel-nginx-deployment-585449566-k5zmp -- /bin/bash
cd /usr/share/nginx/html
echo "Hello, Kubernetes!" > index.html
```
![hw_kub_1 (8).jpg](screenshots%2Fhw_kub_1%20%288%29.jpg)

## Checking the changes
![hw_kub_1 (9).jpg](screenshots%2Fhw_kub_1%20%289%29.jpg)
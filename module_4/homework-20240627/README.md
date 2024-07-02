# Kubernetes ConfigMaps Secrets

[homework-20240627](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240627.md)
## Pull the standard NGINX image:
![kub_5 (1).jpg](screenshots%2Fkub_5%20%281%29.jpg)
## Tag the image and push to private registry
![kub_5 (2).jpg](screenshots%2Fkub_5%20%282%29.jpg)
## Make sure the repository is private
![kub_5 (3).jpg](screenshots%2Fkub_5%20%283%29.jpg)
## 

## Create a Secret for accessing the private registry
```yaml
.
├── .dockerconfigjson
├── ..dockerconfigjson.swp
├── .gitignore
├── k8s-manifests
│   ├── kustomization.yaml
│   ├── yourhostel-nginx-config.yaml
│   ├── yourhostel-nginx-deployment.yaml
│   ├── yourhostel-nginx-service.yaml
│   └── yourhostel-regcred-secret.yaml
└── README.md
```
## `.gitignore`
```gitignore
# Ignore Docker config file
.dockerconfigjson

# Ignore swap files created by text editors
*.swp

# Ignore Kubernetes secret file with sensitive data
yourhostel-regcred-secret.yaml
```
## `.dockerconfigjson`

Encoding a string in base64
```bash
echo -n 'yourusername:yourpassword' | base64
```
![kub_5 (4).jpg](screenshots%2Fkub_5%20%284%29.jpg)
```json
{
  "auths": {
    "https://index.docker.io/v1/": {
      "username": "yourusername",
      "password": "yourpassword",
      "email": "youremail",
      "auth": "dXNlcm5hbWU6cGFzc3dvcmQ="  // This is an example of encoding a string in base64
    }
  }
}
```
## `yourhostel-regcred-secret.yaml`
Encoding the entire .dockerconfigjson file in base64
```bash
cat .dockerconfigjson | base64 -w 0
```
![kub_5 (5).jpg](screenshots%2Fkub_5%20%285%29.jpg)
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: yourhostel-regcred
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <code - the result of encoding .dockerconfigjson file in base64>
```
## Running all manifests
![kub_5 (6).jpg](screenshots%2Fkub_5%20%286%29.jpg)
## Checking the service
![kub_5 (7).jpg](screenshots%2Fkub_5%20%287%29.jpg)
## Deleting all previously created resources
![kub_5 (8).jpg](screenshots%2Fkub_5%20%288%29.jpg)
# Homework AWS ECR ElastiCache SNS SQS Secrets Manager

## 1. Elastic Container Registry
1) Creating an ECR Repository
```bash
aws ecr create-repository --repository-name yourhostel-repo --image-scanning-configuration scanOnPush=true --region eu-north-1
```

![ECR (1).jpg](screenshots%2FECR%20%281%29.jpg)

2) Building a custom image from a [Dockerfile](https://github.com/yourhostel/hw_devops/blob/main/module_3/Homework-ECR-ElastiCache-SNS-SQS-Secrets/ECR/Dockerfile)
```bash
docker build -t yourhostel-repo .
docker tag yourhostel-repo:latest 590184137042.dkr.ecr.eu-north-1.amazonaws.com/yourhostel-repo:latest
```

3) To authenticate to ECR
```bash
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 590184137042.dkr.ecr.eu-north-1.amazonaws.com
```

![ECR (2).jpg](screenshots%2FECR%20%282%29.jpg)

4) Push image to ECR
```bash
docker push 590184137042.dkr.ecr.eu-north-1.amazonaws.com/yourhostel-repo:latest
```

![ECR (3).jpg](screenshots%2FECR%20%283%29.jpg)
![ECR (4).jpg](screenshots%2FECR%20%284%29.jpg)

5) Deleting the ECR repository
```bash
aws ecr delete-repository --repository-name yourhostel-repo --region eu-north-1 --force
```

## 2. ElastiCache
1) Creating an ElastiCache (Redis) Cluster
```bash

```

2) 
```bash

```

3) 
```bash

```
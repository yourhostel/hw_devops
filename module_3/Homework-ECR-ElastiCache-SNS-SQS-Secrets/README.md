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
aws elasticache create-cache-cluster \
--cache-cluster-id yourhostel-cache-cluster \
--engine redis \
--cache-node-type cache.t3.micro \
--num-cache-nodes 1 \
--region eu-north-1
```

![EC (1).jpg](screenshots%2FEC%20%281%29.jpg)
### Creating an EC2 instance
1) Creating a VPC `yourhostel-vpc`
```bash
aws ec2 create-vpc \
--cidr-block 10.0.0.0/16 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=yourhostel-vpc}]'
```

2) Creating a subnet `yourhostel-subnet`
```bash
aws ec2 create-subnet \
--vpc-id vpc-0b6df671cd3d836af \
--cidr-block 10.0.1.0/24 \
--availability-zone eu-north-1a \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=yourhostel-subnet}]'
```

3) Creating an Internet Gateway `yourhostel-igw` and binding it to a VPC
```bash
aws ec2 create-internet-gateway \
--tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=yourhostel-igw}]'

aws ec2 attach-internet-gateway \
--vpc-id vpc-0b6df671cd3d836af \
--internet-gateway-id igw-0425123c9cb16e9e2
```

3) Creating a routing table for Internet access
```bash
aws ec2 create-route-table \
--vpc-id vpc-0b6df671cd3d836af \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=yourhostel-route-table}]'

aws ec2 create-route \
--route-table-id rtb-0768f93e2486add72 \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id igw-0425123c9cb16e9e2

aws ec2 associate-route-table  \
--subnet-id subnet-024c8bc155fcd90ef \
--route-table-id rtb-0768f93e2486add72
```

![EC (2).jpg](screenshots%2FEC%20%282%29.jpg)

4) Creating a Security Group
```bash
aws ec2 create-security-group \
--group-name yourhostel-security-group \
--description "Security group for ElastiCache access and SSH" \
--vpc-id vpc-0b6df671cd3d836af \
--tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=yourhostel-security-group}]'

# For SSH
aws ec2 authorize-security-group-ingress \
--group-id sg-06ba86361618a9cc4 \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0

# For Redis
aws ec2 authorize-security-group-ingress \
--group-id sg-06ba86361618a9cc4 \
--protocol tcp \
--port 6379 \
--cidr 10.0.0.0/16
```
![EC (3).jpg](screenshots%2FEC%20%283%29.jpg)

5) Сreating an EC2 instance
```bash
aws ec2 run-instances \
--image-id ami-05fd03138da450caf \
--count 1 \
--instance-type t3.micro \
--key-name YourHostelKey \
--security-group-ids sg-06ba86361618a9cc4 \
--subnet-id subnet-024c8bc155fcd90ef \
--associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=yourhostel-ElastiCache}]'

# Connect to the instance
ssh -i ~/.ssh/YourHostelKey.pem -p 22 ec2-user@13.51.107.218
```

![EC (4).jpg](screenshots%2FEC%20%284%29.jpg)
![EC (5).jpg](screenshots%2FEC%20%285%29.jpg)

6) Installing Redis CLI on an EC2 instance
```bash
sudo yum update

# The redis package is available through Amazon Linux Extras under the name "redis6"
sudo amazon-linux-extras install redis6 -y
```

7) Connecting to ElastiCache Redis
```bash
aws elasticache describe-cache-clusters \
--cache-cluster-id yourhostel-cache-cluster \
--show-cache-node-info \
--region eu-north-1
```

8)
```bash

```
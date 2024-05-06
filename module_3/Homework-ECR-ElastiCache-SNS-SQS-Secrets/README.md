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

4) Creating a routing table for Internet access
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

5) Creating a Security Group
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

6) Create an IAM policy from [elasticache-policy.json](https://github.com/yourhostel/hw_devops/blob/main/module_3/Homework-ECR-ElastiCache-SNS-SQS-Secrets/ElastiCache/elasticache-policy.json)
```bash
aws iam create-policy \
--policy-name yourhostel-elasticache-policy \
--policy-document file://elasticache-policy.json
```
7) Create an IAM role from [trust-policy.json](https://github.com/yourhostel/hw_devops/blob/main/module_3/Homework-ECR-ElastiCache-SNS-SQS-Secrets/ElastiCache/trust-policy.json)
```bash
aws iam create-role \
--role-name yourhostel-elasticache-role \
--assume-role-policy-document file://trust-policy.json
```

8) Attaching a Policy to a Role
```bash
aws iam attach-role-policy \
--role-name yourhostel-elasticache-role \
--policy-arn arn:aws:iam::590184137042:policy/yourhostel-elasticache-policy
```

9) create IAM Instance Profile
```bash
aws iam create-instance-profile \
--instance-profile-name yourhostel-elasticache-profile
```

10) Attaching a Role to an Instance Profile
```bash
aws iam add-role-to-instance-profile \
--instance-profile-name yourhostel-elasticache-profile \
--role-name yourhostel-elasticache-role 
```

11) Creating a DB Subnet Group for ElastiCache:
```bash
aws elasticache create-cache-subnet-group \
    --cache-subnet-group-name yourhostel-cache-subnet-group \
    --cache-subnet-group-description "Subnet group for yourhostel cache cluster" \
    --subnet-ids "subnet-024c8bc155fcd90ef"
```

12) Creating a Redis Cluster
```bash
aws elasticache create-cache-cluster \
    --cache-cluster-id yourhostel-cache-cluster \
    --engine redis \
    --cache-node-type cache.t3.micro \
    --num-cache-nodes 1 \
    --region eu-north-1 \
    --cache-subnet-group-name yourhostel-cache-subnet-group
```

13) Сreating an EC2 instance
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

# Associating an Instance Profile with an EC2 instance
aws ec2 associate-iam-instance-profile \
--instance-id i-0666a645e77cdacfc \
--iam-instance-profile Name=yourhostel-elasticache-profile

# Connect to the instance
ssh -i ~/.ssh/YourHostelKey.pem -p 22 ec2-user@13.51.107.218
```

![EC (4).jpg](screenshots%2FEC%20%284%29.jpg)
![EC (5).jpg](screenshots%2FEC%20%285%29.jpg)

14) Installing Redis CLI on an EC2 instance
```bash
sudo yum update

# The redis package is available through Amazon Linux Extras under the name "redis6"
sudo amazon-linux-extras install redis6 -y
```

15) Connecting to ElastiCache Redis 
```bash
aws elasticache describe-cache-clusters \
--cache-cluster-id yourhostel-cache-cluster \
--show-cache-node-info \
--region eu-north-1

redis-cli -h yourhostel-cache-cluster.ac1vf1.0001.eun1.cache.amazonaws.com -p 6379
```
![EC (6).jpg](screenshots%2FEC%20%286%29.jpg)

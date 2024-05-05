# Homework AWS VPC
[homework-20240421-vpc](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240421-vpc.md)

1) Creating a VPC: YourhostelVPC
```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=YourhostelVPC}]'
```
![vpc (1).jpg](screenshots%2Fvpc%20%281%29.jpg)
![vpc (2).jpg](screenshots%2Fvpc%20%282%29.jpg)
2) Creating Subnets: PublicSubnet, 
```bash
aws ec2 create-subnet --vpc-id vpc-067060974e501a27d --cidr-block 10.0.1.0/24 --availability-zone eu-north-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PublicSubnet}]'
aws ec2 create-subnet --vpc-id vpc-067060974e501a27d --cidr-block 10.0.2.0/24 --availability-zone eu-north-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PrivateSubnet}]'
```
![vpc (3).jpg](screenshots%2Fvpc%20%283%29.jpg)
![vpc (4).jpg](screenshots%2Fvpc%20%284%29.jpg)
![vpc (5).jpg](screenshots%2Fvpc%20%285%29.jpg)
3) creating an Internet gateway: YourhostelIGW
```bash
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=YourhostelIGW}]'
```
![vpc (6).jpg](screenshots%2Fvpc%20%286%29.jpg)
  * Binding a gateway (YourhostelIGW) to a VPC (YourhostelVPC)
```bash
aws ec2 attach-internet-gateway --internet-gateway-id igw-0640566a26973b3f6 --vpc-id vpc-067060974e501a27d
```
  * Create a Route Table for a public subnet and configure routing
```bash
aws ec2 create-route-table --vpc-id vpc-067060974e501a27d --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=PublicRouteTable}]'
```
  * We route all traffic through Internet Gateway
```bash
aws ec2 create-route --route-table-id rtb-0d0d8de3b7133a9b6 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0640566a26973b3f6
```
 * We bind the public subnet to the created routing table
```bash
aws ec2 associate-route-table --subnet-id subnet-0609bdb938e4d201f --route-table-id rtb-0d0d8de3b7133a9b6
```
![vpc (7).jpg](screenshots%2Fvpc%20%287%29.jpg)
![vpc (8).jpg](screenshots%2Fvpc%20%288%29.jpg)
![vpc (9).jpg](screenshots%2Fvpc%20%289%29.jpg)
4) Creating a NAT Gateway for a private subnet
```bash
# allocate Elastic IP
aws ec2 allocate-address --domain vpc
# Creating a NAT Gateway
aws ec2 create-nat-gateway --subnet-id subnet-0609bdb938e4d201f --allocation-id eipalloc-0a51773c9bfe439dc
# Adding tags to NAT Gateway
aws ec2 create-tags --resources nat-005fad8a76c8e398b --tags Key=Name,Value=YourhostelNAT
```

```bash
# Creating a Route Table for a private subnet
aws ec2 create-route-table --vpc-id vpc-067060974e501a27d --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=PrivateRouteTable}]'
# Add a route to this routing table that will use NAT Gateway to access the Internet
aws ec2 create-route --route-table-id rtb-0c52148eae6fdeb77 --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-005fad8a76c8e398b
# We bind the private subnet to the created routing table
aws ec2 associate-route-table --subnet-id subnet-0e08b65b03d0a63dd --route-table-id rtb-0c52148eae6fdeb77
```
![vpc (10).jpg](screenshots%2Fvpc%20%2810%29.jpg)
![vpc (11).jpg](screenshots%2Fvpc%20%2811%29.jpg)
5) Create a security group for a public subnet
```bash
aws ec2 create-security-group --group-name PublicSG --description "Security group for public subnet" --vpc-id vpc-067060974e501a27d
# Allowing incoming traffic via SSH
aws ec2 authorize-security-group-ingress --group-id sg-0952442aa28b67639 --protocol tcp --port 22 --cidr 0.0.0.0/0
```
![vpc (13).jpg](screenshots%2Fvpc%20%2813%29.jpg)
![vpc (14).jpg](screenshots%2Fvpc%20%2814%29.jpg)

6) Creating a security group for a private subnet
```bash
aws ec2 create-security-group --group-name PrivateSG --description "Security group for private subnet" --vpc-id vpc-067060974e501a27d
# Rule for allowing SSH access only from the public subnet
aws ec2 authorize-security-group-ingress --group-id sg-05e89bad30be89edd --protocol tcp --port 22 --cidr 10.0.1.0/24
```
  * Сommand to find Amazon Linux 2 AMI ID in eu-north-1 region
```bash
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" "Name=state,Values=available" --query "Images[*].[ImageId,CreationDate]" --output text | sort -k2 -r | head -n1
```
![vpc (12).jpg](screenshots%2Fvpc%20%2812%29.jpg)

7) Create a key and save it on the local machine
```bash
aws ec2 create-key-pair --key-name YourHostelKey --query 'KeyMaterial' --output text > ~/.ssh/YourHostelKey.pem
chmod 400 ~/.ssh/YourHostelKey.pem
```

8) Creating EC2 instances with a key YourHostelKey
  * Public instance
```bash
aws ec2 run-instances --image-id ami-05fd03138da450caf --count 1 --instance-type t3.micro --key-name YourHostelKey --security-group-ids sg-0952442aa28b67639 --subnet-id subnet-0609bdb938e4d201f --associate-public-ip-address --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=yourhostel-public}]'
```
  * Private instance
```bash
aws ec2 run-instances --image-id ami-05fd03138da450caf --count 1 --instance-type t3.micro --key-name YourHostelKey --security-group-ids sg-05e89bad30be89edd --subnet-id subnet-0e08b65b03d0a63dd --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=yourhostel-private}]'
```
![vpc (16).jpg](screenshots%2Fvpc%20%2816%29.jpg)

9) Connecting to a public instance
```bash
ssh -i ~/.ssh/YourHostelKey.pem -p 22 ec2-user@51.20.126.3
```
![vpc (17).jpg](screenshots%2Fvpc%20%2817%29.jpg)
10) Connecting to a private instance from a public one
```bash
# Copy the key from the local machine to the public instance
scp -v -i ~/.ssh/YourHostelKey.pem -P 22 ~/.ssh/YourHostelKey.pem ec2-user@51.20.126.3:/home/ec2-user/.ssh/
```
![vpc (18).jpg](screenshots%2Fvpc%20%2818%29.jpg)
```bash
ssh -i ~/.ssh/YourHostelKey.pem ec2-user@10.0.2.238
```
![vpc (19).jpg](screenshots%2Fvpc%20%2819%29.jpg)
# Homework AWS RDS
[homework-20240423-rds](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240423-rds.md)

1) Creating a VPC: `yourhostel-vpc`; Creating Internet Gateway: `yourhostel-igw`
```bash
aws ec2 create-vpc \
--cidr-block 10.0.0.0/16 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=yourhostel-vpc}]'
# Creating an Internet gateway
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=yourhostel-igw}]'
# Let's connect the created Internet gateway to the yourhostel-vpc
aws ec2 attach-internet-gateway \
--internet-gateway-id igw-015339eec3bbaa7f6 \
--vpc-id vpc-04963de75afbd5fd4
# Routes all traffic (0.0.0.0/0) through the Internet gateway
aws ec2 create-route \
--route-table-id rtb-076374f7b0c82b3f0 \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id igw-015339eec3bbaa7f6
```

2) Creating Subnets: `yourhostel-rds-subnet`, `yourhostel-rds-subnet-a` 
  * The availability zone is assigned automatically if not specified explicitly in the command. In this example, the subnet `yourhostel-rds-subnet` has been assigned a zone eu-north-1c.
  * For the zone `yourhostel-rds-subnet-a` the availability zone was explicitly specified in the command.
  * Two availability zones allow you to: improve fault tolerance, use replication functions, and allow flexible load management.
```bash
aws ec2 create-subnet \
--vpc-id vpc-04963de75afbd5fd4 \
--cidr-block 10.0.1.0/24 \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=yourhostel-rds-subnet}]'

aws ec2 create-subnet \
--vpc-id vpc-04963de75afbd5fd4 \
--cidr-block 10.0.2.0/24 \
--availability-zone eu-north-1a \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=yourhostel-rds-subnet-a}]'
```

2) Creating a security group: `yourhostel-security-group`
```bash
aws ec2 create-security-group \
--group-name yourhostel-security-group \
--description "Security group for yourhostel project" \
--vpc-id vpc-04963de75afbd5fd4 \
--tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=yourhostel-security-group}]'

aws ec2 authorize-security-group-ingress \
--group-id sg-067ca77bf3b576d53 \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0
```

3) Adding security group rules for access
```bash
aws ec2 authorize-security-group-ingress \
--group-id sg-067ca77bf3b576d53 \
--protocol tcp \
--port 3306 \
--cidr 0.0.0.0/0
```

4) Creating a DB Subnet Group for RDS
```bash
aws rds create-db-subnet-group \
--db-subnet-group-name yourhostel-db-subnet-group \
--db-subnet-group-description "DB subnet group for yourhostel project" \
--subnet-ids '["subnet-0c57d8975971af631", "subnet-0ee958141626b7d31"]'
```

![RDS (1).jpg](screenshots%2FRDS%20%281%29.jpg)

5) Creating an RDS MySQL DB Instance: `yourhostel-mysql-db`
```bash
aws rds create-db-instance \
    --db-instance-identifier yourhostel-mysql-db \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --allocated-storage 20 \
    --master-username masteruser \
    --master-user-password masterpassword123 \
    --vpc-security-group-ids sg-067ca77bf3b576d53 \
    --db-subnet-group-name yourhostel-db-subnet-group \
    --backup-retention-period 0
```

![RDS (2).jpg](screenshots%2FRDS%20%282%29.jpg)

6) Creating EC2 Instance: `yourhostel-rds`
```bash
aws ec2 run-instances \
    --image-id ami-05fd03138da450caf \
    --count 1 \
    --instance-type t3.micro \
    --key-name YourHostelKey \
    --security-group-ids sg-067ca77bf3b576d53 \
    --subnet-id subnet-0c57d8975971af631 \
    --associate-public-ip-address \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=yourhostel-rds}]' 
```

![RDS (3).jpg](screenshots%2FRDS%20%283%29.jpg)

7) Connecting to the instance `yourhostel-rds`
```bash
ssh -i ~/.ssh/YourHostelKey.pem -p 22 ec2-user@16.16.99.176
```

![RDS (4).jpg](screenshots%2FRDS%20%284%29.jpg)

8) Installing MySQL client
```bash
sudo yum install mysql -y
```

![RDS (5).jpg](screenshots%2FRDS%20%285%29.jpg)

9) Connecting to the database endpoint: 

![RDS (6_1).jpg](screenshots%2FRDS%20%286_1%29.jpg)

```bash
mysql -h yourhostel-mysql-db.cxwoekqqetn5.eu-north-1.rds.amazonaws.com -u masteruser -p
```
![RDS (6).jpg](screenshots%2FRDS%20%286%29.jpg)

10) Create the `yourhostel_db` database, use it to create the `test_table` table, add 3 `Item`-s to the table, and get all the added data `SELECT * FROM test_table;`

![RDS (7).jpg](screenshots%2FRDS%20%287%29.jpg)

11) Removing an RDS instance
```bash
aws rds delete-db-instance --db-instance-identifier yourhostel-mysql-db --skip-final-snapshot
```

12) Stopping and deleting an EC2 instance
```bash
aws ec2 terminate-instances --instance-ids i-0fc4ffed4ba81e1e5
```

13) Removing a VPC
```bash
aws ec2 delete-vpc --vpc-id vpc-04963de75afbd5fd4
```
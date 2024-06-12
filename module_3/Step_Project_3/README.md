# Step Project 3
[link](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240528.md)

## Project Overview
This project involves creating a scalable monitoring infrastructure on AWS using Terraform and Ansible. The setup includes a VPC, security groups, EC2 instances with Docker installed, and the deployment of Prometheus, Grafana, Node Exporter, and cAdvisor.

## Automated Provisioning Logic

### Inventory File Management
- The project automatically verifies the existence of the `inventory.ini` file.
- If found, it deletes the existing `inventory.ini` file and generates a new one with the updated infrastructure details.

```inventory.tpl
# terraform/inventory.tpl

[all]
%{ for ip in public_ips ~}
${ip} ansible_host=${ip} ansible_user=${ansible_user} ansible_port=${ansible_port} ansible_ssh_private_key_file=${private_key}
%{ endfor ~}

[all:vars]
prometheus_port=${prometheus_port}
grafana_port=${grafana_port}
node_exporter_port=${node_exporter_port}
cadvisor_port=${cadvisor_port}
```
### SSH Connectivity Check
- Before running the Ansible playbook, the project verifies SSH connectivity to all EC2 instances.
- The `null_resource "wait_for_ssh"` resource checks if SSH is available on each instance.
- It tries to connect to the instance for up to 30 attempts, pausing for 5 seconds between each attempt.

```tf
resource "null_resource" "wait_for_ssh" {
  count = length(module.ec2.public_ips)

  provisioner "local-exec" {
    command = <<EOT
    for i in {1..30}; do
      nc -zv ${element(module.ec2.public_ips, count.index)} 22 && break
      echo "Waiting for SSH to be available on ${element(module.ec2.public_ips, count.index)}..."
      sleep 5
    done
    EOT
  }
}
```

### Ansible Provisioning
- Once SSH connectivity is confirmed, the Ansible playbook is triggered.
- The `null_resource "ansible_playbook"` resource runs the Ansible playbook to configure Prometheus, Grafana, Node Exporter, and cAdvisor on the EC2 instances.

```tf
resource "null_resource" "ansible_playbook" {
  depends_on = [
    module.ec2,
    null_resource.wait_for_ssh
  ]

  provisioner "local-exec" {
    command = <<EOT
    ANSIBLE_CONFIG=${path.module}/../ansible/ansible.cfg \
    ansible-playbook -i ${path.module}/../ansible/inventory.ini \
    ${path.module}/../ansible/playbooks/deploy.yml
    EOT
  }
}
```
### Outputs:

- `api_endpoints`: Provides URLs for accessing Prometheus, Grafana, and cAdvisor on the EC2 instances.
- `instance_ids`: Lists the IDs of the created EC2 instances.
- `instance_public_ips`: Lists the public IP addresses of the created EC2 instances.
- `security_group_id`: The ID of the created security group.
- `vpc_id`: The ID of the created VPC.

![step_project_3 (1).jpg](screenshots%2Fstep_project_3%20%281%29.jpg)
###  prometheus http://16.16.215.106:9090
![step_project_3 (2).jpg](screenshots%2Fstep_project_3%20%282%29.jpg)
### node_exporter_3 http://13.53.89.137:9100
![step_project_3 (3).jpg](screenshots%2Fstep_project_3%20%283%29.jpg)
### node_exporter_2 http://13.60.50.11:9100
![step_project_3 (4).jpg](screenshots%2Fstep_project_3%20%284%29.jpg)
### node_exporter_1 http://16.16.215.106:9100
![step_project_3 (5).jpg](screenshots%2Fstep_project_3%20%285%29.jpg)
### cadvisor_2 http://13.53.89.137:8080
![step_project_3 (6).jpg](screenshots%2Fstep_project_3%20%286%29.jpg)
### cadvisor_1 http://16.16.215.106:8080
![step_project_3 (7).jpg](screenshots%2Fstep_project_3%20%287%29.jpg)
### grafana http://16.16.215.106:3000 
The drop-down list allows you to switch between instances. I used a dashboard with ID 1860 "Node Exporter Full" to monitor system metrics using Prometheus and Node Exporter.
![step_project_3 (8).jpg](screenshots%2Fstep_project_3%20%288%29.jpg)
### Instances
names are formed from: [module ec2](https://github.com/yourhostel/hw_devops/tree/main/module_3/Step_Project_3/terraform/modules/ec2) 
```bash
  tags = {
    Name      = "${var.name}-step-project-3-${count.index + 1}"
    # ...
  }
```
![step_project_3 (9).jpg](screenshots%2Fstep_project_3%20%289%29.jpg)
### VPC
from [module vpc](https://github.com/yourhostel/hw_devops/blob/main/module_3/Step_Project_3/terraform/modules/vpc)
![step_project_3 (10).jpg](screenshots%2Fstep_project_3%20%2810%29.jpg)
### yourhostel-sg
from [module security_group](https://github.com/yourhostel/hw_devops/tree/main/module_3/Step_Project_3/terraform/modules/security_group)
![step_project_3 (11).jpg](screenshots%2Fstep_project_3%20%2811%29.jpg)
### yourhostel-lb
from [module load_balancer](https://github.com/yourhostel/hw_devops/tree/main/module_3/Step_Project_3/terraform/modules/load_balancer)
![step_project_3 (12).jpg](screenshots%2Fstep_project_3%20%2812%29.jpg)
### diagram
![infrastructure_diagram.png](diagram%2Finfrastructure_diagram.png)

#### example of project variables terraform.tfvars

```terraform.tfvars
name                = "yourhostel"
aws_region          = "eu-north-1"
instance_count      = 3
ami_id              = "ami-05fd03138da450caf"
instance_type       = "t3.micro"
key_name            = "YourHostelKey"
vpc_cidr            = "10.0.0.0/16"
vpc_azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
enable_nat_gateway  = true
single_nat_gateway  = true

ansible_user           = "ec2-user"
ansible_port           = 22
prometheus_port        = 9090
grafana_port           = 3000
node_exporter_port     = 9100
cadvisor_port          = 8080
private_key            = "~/.ssh/YourHostelKey.pem"
```


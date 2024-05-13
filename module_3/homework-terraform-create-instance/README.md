# Homework Terraform Create Instance AWS EC2 and Backend for state and push to AWS S3 
[homework-20240512](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240512.md?ref_type=heads)

## Create Instance

```bash
terraform init
terraform plan
terraform apply
```

![tr (1).jpg](screenshots%2Ftr%20%281%29.jpg)

- [***vpc***](https://github.com/yourhostel/hw_devops/tree/main/module_3/homework-terraform-create-instance/modules/vpc)

![tr (2).jpg](screenshots%2Ftr%20%282%29.jpg)

- [***security_group***](module_3/homework-terraform-create-instance/modules/security_group/main.tf)

-  [***List of ports to be opened***](module_3/homework-terraform-create-instance/variables.tf)

![tr (3).jpg](screenshots%2Ftr%20%283%29.jpg)

- [***instance***](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-terraform-create-instance/modules/ec2/main.tf)

![tr (4).jpg](screenshots%2Ftr%20%284%29.jpg)

![tr (5).jpg](screenshots%2Ftr%20%285%29.jpg)

## Backend
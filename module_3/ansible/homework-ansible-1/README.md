# homework-20240523
[link](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240523.md)

```bash
terraform apply
```
![2024-05-26_000329.jpg](screenshots%2F2024-05-26_000329.jpg)

- inventory.ini file is created using [./terraform/main.tf](https://github.com/yourhostel/hw_devops/blob/main/module_3/ansible/homework-ansible-1/terraform/main.tf)  and [./terraform/inventory.tpl](https://github.com/yourhostel/hw_devops/blob/main/module_3/ansible/homework-ansible-1/terraform/inventory.tpl) 
```tf
resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    instances = module.ec2.public_ips
  })
  filename = "${path.module}/../ansible/inventory.ini"
}
```

![2024-05-26_013656.jpg](screenshots%2F2024-05-26_013656.jpg)

```bash
ansible-playbook playbooks/deploy.yml
```

![2024-05-26_013617.jpg](screenshots%2F2024-05-26_013617.jpg)
![2024-05-26_021941.jpg](screenshots%2F2024-05-26_021941.jpg)
![2024-05-26_013746.jpg](screenshots%2F2024-05-26_013746.jpg)
![2024-05-26_021901.jpg](screenshots%2F2024-05-26_021901.jpg)
![2024-05-26_013759.jpg](screenshots%2F2024-05-26_013759.jpg)
![2024-05-26_013839.jpg](screenshots%2F2024-05-26_013839.jpg)
![2024-05-26_014121.jpg](screenshots%2F2024-05-26_014121.jpg)
![2024-05-26_014221.jpg](screenshots%2F2024-05-26_014221.jpg)
![2024-05-26_014302.jpg](screenshots%2F2024-05-26_014302.jpg)
# homework-20240523
[link](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240526.md)

```bash
terraform apply
```

- inventory.ini file is created using [./terraform/main.tf]()  and [./terraform/inventory.tpl]() 

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
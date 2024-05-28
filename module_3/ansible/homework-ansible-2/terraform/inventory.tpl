# terraform/inventory.tpl

[all]
%{ for instance in instances ~}
${instance} ansible_host=${instance} ansible_port=22
%{ endfor ~}

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=~/.ssh/YourHostelKey.pem
nginx_port=${nginx_port}
name=${name}
instances=%{ for instance in jsondecode(instances) }${instance.public_ip}:{% raw %}{{% endraw %}{{ instance.port }}{% raw %}}{% endfor %}
open_ports=%{ for port in jsondecode(open_ports) }${port}{% if not loop.last %},{% endif %}{% endfor %}
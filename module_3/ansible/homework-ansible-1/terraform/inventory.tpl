[all]
%{ for instance in instances ~}
${instance.tags.Name} ansible_host=${instance.public_ip}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/YourHostelKey.pem
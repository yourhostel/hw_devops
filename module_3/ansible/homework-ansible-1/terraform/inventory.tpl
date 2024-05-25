[all]
%{ for instance in instances ~}
${instance} ansible_host=${instance} ansible_port=22
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/YourHostelKey.pem
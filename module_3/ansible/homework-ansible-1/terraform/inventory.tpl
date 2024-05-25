[all]
%{ for instance in instances ~}
${instance} ansible_host=${instance}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/YourHostelKey.pem
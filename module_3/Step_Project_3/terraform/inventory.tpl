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



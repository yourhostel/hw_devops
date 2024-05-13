output "instance_ip" {
  description = "Публічна IP адреса EC2 інстансу"
  value       = module.yourhostel_ec2.instance_ip
}

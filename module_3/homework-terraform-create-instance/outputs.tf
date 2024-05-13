output "instance_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.yourhostel_ec2.instance_ip
}

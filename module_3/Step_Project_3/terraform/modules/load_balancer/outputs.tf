# Step_Project_3/terraform/load_balancer/outputs.tf

output "elb_dns_name" {
  value = aws_elb.this.dns_name
}



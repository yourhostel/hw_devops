# Step_Project_3/terraform/load_balancer/outputs.tf

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.this.dns_name
}


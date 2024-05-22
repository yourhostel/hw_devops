# modules/VPC/outputs.tf

output "vpc_id" {
  value = aws_vpc.yourhostel_vpc.id
}

output "public_subnets" {
  value = aws_subnet.yourhostel_public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.yourhostel_private_subnet.*.id
}
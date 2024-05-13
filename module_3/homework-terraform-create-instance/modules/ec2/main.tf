resource "aws_instance" "yourhostel_web" {
  ami           = "ami-0e342d72b12109f91" # AMI для Ubuntu з NGINX
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "yourhostel-web-server"
  }
}



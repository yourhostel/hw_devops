resource "aws_instance" "yourhostel_web" {
  ami           = "ami-05fd03138da450caf"
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = "YourHostelKey"

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



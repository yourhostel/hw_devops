# Step_Project_3/terraform/modules/ec2/main.tf

resource "aws_instance" "this" {
  count = var.instance_count

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = element(var.subnet_ids, count.index)
  associate_public_ip_address = true

  tags = {
    Name      = "${var.name}-step-project-3-${count.index + 1}"
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]

    connection {
      type        = "ssh"
      user        = var.ansible_user
      private_key = file(var.private_key)
      host        = self.public_ip
    }
  }
}









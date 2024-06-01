# Step_Project_3/terraform/modules/ec2/main.tf

resource "aws_instance" "this" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = element(var.subnet_ids, count.index)
  security_groups = [var.security_group_id]

  tags = {
    Name      = "${var.name}-step-project-3-${count.index + 1}"
    Owner     = var.name
    CreatedBy = "${var.name}-automation"
    Purpose   = "step3"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo usermod -aG docker ${var.ansible_user}"
    ]

    connection {
      type        = "ssh"
      user        = var.ansible_user
      private_key = file(var.private_key)
      host        = self.public_ip
    }
  }
}





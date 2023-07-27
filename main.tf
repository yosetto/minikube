provider "aws" {
   region = var.aws_region
   skip_credentials_validation = true
}

resource "aws_instance" "minikube" {
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = "${var.key_name}"
  tags = {
    Name = "Caspar_Minikube"
  }

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "${var.ssh_user}"
      private_key = file("./${var.key_name}.pem")
    }
    
    inline = [
      "sudo apt-get remove docker docker-engine docker.io containerd runc",
      "sudo apt-get update",
      "sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get -y install docker-ce docker-ce-cli containerd.io",
      "sudo usermod -aG docker $USER",
      "newgrp docker",
      "curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
      "chmod +x kubectl",
      "mkdir -p ~/.local/bin",
      "mv ./kubectl ~/.local/bin/kubectl",
      "curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo install minikube-linux-amd64 /usr/local/bin/minikube",
      "minikube start"
    ]
  }
}
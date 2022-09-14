variable "profile" {
  type = string
}
variable "region" {
  type = string
}
variable "key_name" {
  type = string
}
variable "key_path" {
  type = string
}
variable "registry" {
  type = string
}
variable "registry_username" {
  type = string
}
variable "registry_password" {
  type = string
}
variable "gitlab_runner_registration_token" {
  type = string
}
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
provider "aws" {
  profile = var.profile
  region  = var.region
}
resource "aws_security_group" "allow_ssh_gitlab_demo" {
  name = "allow_ssh_gitlab_demo"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "ubuntu" {
  tags          = { "Name" = "gitlab-demo" }
  ami           = "ami-0fc20dd1da406780b"
  instance_type = "t2.xlarge"
  root_block_device { volume_size = 16 }
  security_groups = [aws_security_group.allow_ssh_gitlab_demo.name]
  key_name        = var.key_name
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_path)
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      # install Docker Engine
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      # install and run Anchore Engine via Docker Compose
      "sudo apt install -y docker-compose",
      "curl https://docs.anchore.com/current/docs/engine/quickstart/docker-compose.yaml > docker-compose.yaml",
      "sudo docker-compose up -d",
      "sudo docker-compose exec api anchore-cli system wait",
      # add your registry to Anchore Engine
      "sudo docker-compose exec api anchore-cli registry add ${var.registry} ${var.registry_username} ${var.registry_password}",
      # install Anchore CLI
      "sudo apt-get update",
      "sudo apt-get install -y python-pip",
      "pip install --user --upgrade anchorecli",
      # install, register, and start GitLab runner
      "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash",
      "sudo apt-get install gitlab-runner",
      "sudo gitlab-runner register -n -u https://gitlab.com/ -r ${var.gitlab_runner_registration_token} --name gitlab-demo-runner --tag-list gitlab-demo --executor shell --env ANCHORE_CLI_URL_REGION=${var.region}",
      "sudo gitlab-runner status",
      "sudo usermod -aG docker gitlab-runner",
      # install dependency for docker login issue
      "sudo apt install -y gnupg2 pass"
    ]
  }
}
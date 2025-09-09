provider "aws" {
  region = var.region     # <- no quotes
}


data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu_noble" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_security_group" "web_sg" {
  name        = "${var.terraform-ansible-stack}-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "${var.terraform-ansible-stack}-sg"
  }

}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu_noble.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.terraform-ansible-stack
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }

  

}
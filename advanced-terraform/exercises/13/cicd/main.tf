provider "aws" {
  region     = "us-west-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-di-christian"
    key            = "cicd/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
  }
}

resource "tls_private_key" "cicd" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cicd" {
  key_name   = "di-tf-cicd"
  public_key = tls_private_key.cicd.public_key_openssh
}

resource "aws_instance" "cicd" {
  ami                         = "ami-0d382e80be7ffdae5"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.cicd.id]
  user_data                   = data.template_file.user_data.rendered
  key_name                    = aws_key_pair.cicd.key_name
  associate_public_ip_address = true

  tags = {
    Name = "di-tf-cicd"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
}

resource "aws_security_group" "cicd" {
  name = "cicd-instance"
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.cicd.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_server_http_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.cicd.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "website" {
  value = "http://${aws_instance.cicd.public_dns}"
}
resource "tls_private_key" "atlantis" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "atlantis" {
  key_name   = "di-tf-atlantis"
  public_key = tls_private_key.atlantis.public_key_openssh
}

resource "aws_instance" "atlantis" {
  ami                         = "ami-0d382e80be7ffdae5"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.instance.id]
  user_data                   = data.template_file.user_data.rendered
  key_name                    = aws_key_pair.atlantis.key_name
  associate_public_ip_address = true

  tags = {
    Name = "di-tf-atlantis"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
}

data "template_file" "atlantis" {
  template = file("${path.module}/atlantis.sh")

  vars = {
    ATLANTIS_HOST = aws_instance.atlantis.public_dns
    USERNAME      = var.username
    TOKEN         = var.token
    SECRET        = var.secret
    GIT_HOST      = var.git_host
    REPOSITORY    = var.repository
  }
}

resource "aws_security_group" "instance" {
  name = "atlantis-instance"
}

resource "aws_security_group_rule" "allow_server_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = 22
  to_port     = 22
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_server_atlantis_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = 4141
  to_port     = 4141
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_server_http_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = local.all_ips
}

resource "null_resource" "atlantis" {

  triggers = {
    public_ip = aws_instance.atlantis.public_ip,
    template  = data.template_file.atlantis.rendered,
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.atlantis.private_key_pem
    host        = aws_instance.atlantis.public_ip
  }

  provisioner "file" {
    content     = data.template_file.atlantis.rendered
    destination = "/home/ubuntu/atlantis.sh"
  }

  provisioner "file" {
    source      = "atlantis.service"
    destination = "/home/ubuntu/atlantis.service"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /home/ubuntu/atlantis.sh",
      "sudo chown root:root atlantis.service",
      "sudo mv atlantis.service /etc/systemd/system/atlantis.service",
      "sudo systemctl enable atlantis.service",
      "sudo systemctl start atlantis.service"
    ]
  }
}

resource "local_file" "atlantis_pem" {
  filename = "${path.module}/atlantis.pem"
  content  = tls_private_key.atlantis.private_key_pem
}
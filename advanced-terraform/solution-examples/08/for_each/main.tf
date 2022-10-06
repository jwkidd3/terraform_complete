resource "aws_instance" "bastion" {
  for_each = toset(var.users)

  ami                    = "ami-0d382e80be7ffdae5"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.common[each.key].id]

  tags = {
    Name = "bastion-${each.key}"
  }
}

resource "aws_security_group" "common" {
  for_each    = toset(var.users)
  name        = "common-${each.key}"
  description = "Allow inbound traffic to common ports and CIDRs"

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "common-${each.key}"
  }
}

variable "ingress_rules" {
  type = map(string)
  default = {
    443 = "0.0.0.0/0",
    22  = "192.168.48.0/24"
  }
}

variable "users" {
  type    = list(string)
  default = ["john", "paul", "mindy"]
}

output "private_ips" {
  value = values(aws_instance.bastion)[*].private_ip
}

output "security_groups" {
  value = values(aws_security_group.common)[*].id
}
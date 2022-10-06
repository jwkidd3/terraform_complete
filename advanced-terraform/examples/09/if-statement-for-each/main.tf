resource "aws_security_group" "common" {
  name        = "common-for-each"
  description = "Allow inbound traffic to common ports and CIDRs"

  dynamic "ingress" {
    for_each = {
      for key, value in var.ingress_rules :
      key => upper(value) // Converts the value to UPPER case
      if key != "22" // Filter any rule for SSH port
    }

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
    Name = "common-for-each"
  }
}

variable "ingress_rules" {
  type = map(string)
  default = {
    # 443 = "0.0.0.0/0",
    # 22  = "192.168.48.0/24"
  }
}
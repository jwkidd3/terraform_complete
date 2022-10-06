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

variable "users" {
  type    = list(string)
  default = ["john", "paul", "mindy"]
  // TRY: What happens when you delete "paul"? Why it tries to create/destroy? 
}

variable "ingress_rules" {
  type = map(string)
  default = {
    443 = "0.0.0.0/0",
    22  = "192.168.48.0/24"
  }
}

output "security_groups" {
  value = values(aws_security_group.common)[*].id
}

// Loops with for Expressions
output "users_in_upper" {
  value = [for user in var.users : upper(user)]
}

output "users_short" {
  value = [for user in var.users : upper(user) if length(user) < 5]
}

output "port_cidr" {
  value = [for port, cidr in var.ingress_rules : "${port} open for ${cidr}"]
}

// Loops with the for String Directive
output "template" {
  value = <<EOF
%{~ for user in var.users}
  ${user}
%{~ endfor}
EOF
}
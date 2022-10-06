resource "aws_instance" "bastion" {
  count = length(var.users)

  ami           = "ami-0d382e80be7ffdae5"
  instance_type = "t2.micro"

  tags = {
    Name = "bastion-${var.users[count.index]}"
  }
}

variable "users" {
  type    = list(string)
  default = ["john", "paul", "mindy"]
}

output "private_ips" {
  value = aws_instance.bastion[*].private_ip
}
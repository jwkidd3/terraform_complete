locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

variable "username" {}
variable "token" {}
variable "secret" {}
variable "git_host" {}
variable "repository" {}

output "atlantis-dns" {
  value = aws_instance.atlantis.public_dns
}

output "atlantis-url" {
  value = "http://${aws_instance.atlantis.public_dns}:4141"
}
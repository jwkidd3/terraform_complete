resource "aws_security_group" "web_server" {
  name   = "${var.student_alias}-${var.name}"
  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.secgroup_rules
    content {
      from_port   = ingress.key
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  # This is here because aws_launch_configuration.web_servers sets create_before_destroy to true and depends on this
  # resource
  lifecycle {
    create_before_destroy = true
  }
}
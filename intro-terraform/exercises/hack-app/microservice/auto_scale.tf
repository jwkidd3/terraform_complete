resource "aws_launch_template" "microservice" {
  name          = "${var.student_alias}-${var.name}"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  user_data     = templatefile(var.user_data_script,{server_http_port="8080",server_text="Hello Dawg!"})
  key_name               = var.key_name
  vpc_security_group_ids = aws_security_group.web_server.*.id

  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
       Name="${var.student_alias}-${var.name}"
    }
  }
}

resource "aws_autoscaling_group" "microservice" {
  name                = aws_launch_template.microservice.name
  vpc_zone_identifier = data.aws_subnets.default.ids
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.microservice.id
    version = "$Latest"
  }
}
# if-statement with count
resource "aws_instance" "bastion" {
  count         = var.include_bastion ? 1 : 0
  ami           = "ami-0d382e80be7ffdae5"
  instance_type = var.instance_type

  tags = {
    Name = "bastion"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = var.include_bastion && format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "bastion-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    InstanceId = aws_instance.bastion[0].id
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}

variable "include_bastion" {
  type = bool
}

variable "instance_type" {
  default = "t2.micro"

}

# if-else statement
resource "aws_instance" "web" {
  ami           = "ami-0d382e80be7ffdae5"
  instance_type = var.instance_type

  user_data = (
    length(data.template_file.user_data[*]) > 0
    ? data.template_file.user_data[0].rendered
    : data.template_file.user_data_extra[0].rendered
  )

#   user_data = (
#     var.enable_extra_user_data
#     ? data.template_file.user_data_extra[0].rendered
#     : data.template_file.user_data[0].rendered
#   )

  tags = {
    Name = "bastion"
  }
}

data "template_file" "user_data" {
  count = var.enable_extra_user_data ? 0 : 1

  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = 8080
    db_address  = "localhost"
    db_port     = 3306
  }
}

data "template_file" "user_data_extra" {
  count = var.enable_extra_user_data ? 1 : 0

  template = file("${path.module}/user-data-extra.sh")

  vars = {
    server_port = 8080
  }
}

variable "enable_extra_user_data" {
  type = bool
}
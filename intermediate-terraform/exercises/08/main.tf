terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_invalid_resource_type" "name" {
  id = "${var.student_alias}-01"
}

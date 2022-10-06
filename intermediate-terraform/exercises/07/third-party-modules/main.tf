terraform {
  backend "s3" {}
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

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"
  name    = "${var.student_alias}-sg"
}

module "dynamodb_table" {
  source    = "github.com/terraform-aws-modules/terraform-aws-dynamodb-table?ref=v1.0.0"
  name      = "${var.student_alias}-table"
  hash_key  = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]
}

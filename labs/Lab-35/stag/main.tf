#-------------------------------------------------------------------------------
#  Terraform  
#
#  Call Global Variables module and use their outputs
#
#  
#-------------------------------------------------------------------------------
provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

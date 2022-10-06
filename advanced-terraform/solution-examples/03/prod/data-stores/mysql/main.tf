provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket         = "<YOUR S3 BUCKET>"
    key            = "<SOME PATH>/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "<YOUR DYNAMODB TABLE>"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = var.db_name
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = true
}

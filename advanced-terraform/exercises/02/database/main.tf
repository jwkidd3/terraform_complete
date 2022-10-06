provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-di-christian"
    key            = "mystudentalias/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = var.db_name
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_stage"
}

output "address" {
  value       = aws_db_instance.example.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "The port the database is listening on"
}
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

module "database" {
  source = "../../../modules/services/database"

  db_name     = var.db_name
  db_password = var.db_password
}

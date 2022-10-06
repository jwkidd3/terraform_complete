provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket  = "terraform-di-christian"
    key     = "mystudentalias/prod-database.tfstate"
    region  = "us-west-1"
    encrypt = true
  }
}

module "database" {
  source      = "github.com/christianhxc/tf-adv-database//src?ref=v0.1.0"
  db_password = "P4ssw0rd"
}

output "address" {
  value       = module.database.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.database.port
  description = "The port the database is listening on"
}
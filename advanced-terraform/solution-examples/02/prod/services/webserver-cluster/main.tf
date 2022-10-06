provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket  = "terraform-di-christian"
    key     = "mystudentalias/prod-webserver.tfstate"
    region  = "us-west-1"
    encrypt = true
  }
}

module "webserver" {
  source              = "../../../modules/services//webserver-cluster"
  cluster_name        = "di-tf-advanced-terraform-prod"
  instance_type       = "t2.large"
  ami                 = "ami-0d382e80be7ffdae5"
  remote_db_state_key = "mystudentalias/prod-database.tfstate"
}
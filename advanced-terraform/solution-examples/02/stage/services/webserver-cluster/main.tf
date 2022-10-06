provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket  = "terraform-di-christian"
    key     = "mystudentalias/stage-webserver.tfstate"
    region  = "us-west-1"
    encrypt = true
  }
}

module "webserver" {
  source              = "../../../modules/services//webserver-cluster"
  cluster_name        = "di-tf-advanced-terraform"
  instance_type       = "t2.micro"
  ami                 = "ami-0d382e80be7ffdae5"
  remote_db_state_key = "mystudentalias/terraform.tfstate"
}
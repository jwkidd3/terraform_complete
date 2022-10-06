provider "aws" {
  region  = local.env[terraform.workspace].region
}

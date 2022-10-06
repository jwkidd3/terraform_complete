remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "terraform-di-christian"

    key            = "cmelendez/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "cmelendez"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-2"

  default_tags {
   tags = {
     CostCenter  = "tf-advanced"
     Project     = "Terraform-Advanced"
   }
 }
}
EOF
}

terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]

    required_var_files = [
      "${get_parent_terragrunt_dir()}/commons/common.tfvars"
    ]

    optional_var_files = [
      "${get_terragrunt_dir()}/database.tfvars",
      "${get_terragrunt_dir()}/webserver.tfvars"
    ]

    arguments = [
      "-lock-timeout=20m"
    ]
  }
}

# Exercise #4: Terragrunt Refactoring (45m)
We're going to refactor the existing Terraform templates we've been using in the previous exercise. You could create a copy of the templates or use the existing one. Also, you need to destroy any existing infrastructure before you start because you'll be creating resources for at least two environments (something similar to what you did before). It's up to you if you decide for going with a more realistic approach and not deleting any existing infrastructure and then apply the refactos you'll do here.

## Generating the Backend Configuration

So, let's get started by creating the `terragrunt.hcl` file in the root directory of the project (where you have both environments) and in each of the the modules (for the web server and for the databse). Your directory structure should look similar to this:

```
├── terragrunt.hcl
├── stage
│   ├── services
│   │   └── webserver-cluster
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       └── terragrunt.hcl
│   ├── data-stores
│   │   └── mysql
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       └── terragrunt.hcl
├── prod
│   ├── services
│   │   └── webserver-cluster
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       └── terragrunt.hcl
│   ├── data-stores
│   │   └── mysql
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       └── terragrunt.hcl
```

Then include the following configuration for the root `terragrunt.hcl` file:

```
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "YOUR_BUCKET_NAME"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "YOUR_BUCKET_REGION"
    encrypt        = true
    dynamodb_table = "YOUR_STUDENT_ALIAS"
  }
}
```

Then, use the following configuration for each `terragrunt.hcl` file within each service:

```
include {
  path = find_in_parent_folders()
}
```

You're simply referencing the main configuration file, nothing else (at least for now). You can always add any other specific configurations for each service or module. 

Let's start testing what we've done so far and deploy the database for the stage environment:

```
cd stage/data-stores/mysql
terragrunt apply
```

You might see an error saying that you have a duplicate backend. This is because in the root configuration file you're defining which backend solution to use. Terragrunt will generate the backend configuration for you so you need to remove any existing configuration to avoid conflicts. Fix that problem before proceeding, and try to create the database again.

Notice that you didn't need to run the init command, Terragrunt does that for you.

Wait for a few minutes for the RDS to be ready.

## Generating the Provider Configuration

Another useful feature from Terragrunt is that you can configure the provider information for all your modules in one place. Remember, a best practice is not include this type of configuration inside a module, that's why you need to define it when you use a module.

Again, same as before, make sure you delete any previous configuration for the provider. You can't have multiple provider configuration in an HCL template. Remember, Terraform merges all .tf files at runtime.

Modify the `terragrunt.hcl` file in the root directory, and include the following:

```
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
```

Notice how we're not just configuring the default region but we're also configuring global tags for every resource you create. Let's run the apply command again:

```
terragrunt apply
```

You shouldn't see any big changes, except the one where it adds more tags to the resources. If for some reason you see that the RDS instance is going to be re-created, that might be because you were using a different AWS region (it happened to me).

## Configuring Input Variables
At this point, Terraform has been asking you to enter the database password every time you run the apply command. Unless you've fixed that, Terragrunt will continue asking you that. Luckly, Terragrung also has support for sending parameters in the CLI and you can define that configuration in the HCL file.

So let's go back and edit the `terragrunt.hcl` file in the root directory, and add the following content:

```
terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]

    required_var_files = [
      "${get_parent_terragrunt_dir()}/commons/common.tfvars"
    ]

    optional_var_files = [
      "${get_terragrunt_dir()}/database.tfvars"
    ]

    arguments = [
      "-lock-timeout=20m"
    ]
  }
}
```

Notice how you're configuring which arguments to send every time you run `plan` or `apply`, and you're also configuring required and optional var files. I'm including both so that you can see how to do it, but we're not going to configure any global variable. So, go ahead and create the `common.tfvars` file in the `commons` folder at the root directory (that folder is new, so you need to create it as well). The content of that file should be empty, but that's where you could include for example the AWS region you'd like to use. Run the following commands:

```
mkdir -p commons
touch commons/common.tfvars
```

Notice that you also have some optional var files. The reason you had to create an empty file before it's because if you don't have it, Terragrunt will complaint. However, there are going to be times where you want to have var files that doesn't exist in all modules. In this case, we're referencing the `database.tfvars` that should only exist in the database modules and here's where you'll define a value for the database password. I know that this is not secure, but it's to give you an idea of what you can do.

So create the `database.tfvars` file in the database module, like this:

```
touch database.tfvars
```

And include the following content:

```
db_password = "P4ssw0rd"
```

Run the apply command again, Terragrunt shouldn't be asking you for the password.

```
terragrunt apply
```

And as expected, no changes should be made in the database.

## Refactor the Webserver Module
Change directory, and go to the one for the webserver. You shoudl remove the duplicate provider configuration and reference the local module, not the one in GitHub as you did previously. That means that for now, you need to recreate the `modules` folder, and have the code locally. Again, we're not going to be referencing modules from GitHub, at least not for now. You can copy the modules folder from the folder `/advanced-terraform/examples/04/v0.0.1/modules/` insid this repository. Your module source should look like this:

```
source = "../../../modules/services/webserver-cluster"
```

Run the `terragrunt apply` command and fix any issues you might found (like improper required version). DON'T PROCEED with creating the resources, Terragrunt should be asking you about the remote state bucket to get the output values from the database module. Terragrunt has a better way to handle this, so we'll be doing a big refactor now.

Cancel the apply command, and let's start making some changes to the templates.

I'm not going to give you detailed instructions this time, but before you use the Terragrunt magic you need to remove the following things:

* Remove the `db_remote_state_bucket` and `db_remote_state_key` variables from the webserver module (`modules/services/webserver-cluster/variables.tf`)
* Remove the `db_remote_state_bucket` and `db_remote_state_key` variables from the webserver implementation (`stage/services/webserver-cluster/variables.tf`)
* Remove the `terraform_remote_state.db` resource form the `main.tf` file

Edit the `terragrunt.hcl` file that you created for the webserver module at `stage/services/webserver-cluster` and add the following content:

```
dependency "rds" {
  config_path = "../../data-stores/mysql"
}

inputs = {
  db_address = dependency.rds.outputs.address
  db_port = dependency.rds.outputs.port
}
```

Notice that here, you're adding a dependency from the databse module. This means that Terragrunt is going to be able to query the state for that module. In other words, we're interesting in the database address and port from that module. That's why the above change includes an `inputs` section where you reference the outputs from the database module and include them as input variables in the webserver module.

These variables doesn't exist yet, so you need to add them in the `variables.tf` file from the webserver-cluster implementation (`stage/services/webserver-cluster/variables.tf`) and in the webserver-cluster module (`modules/services/webserver-cluster/variables.tf`) as well:

```
variable "db_address" {}
variable "db_port" {}
```

Go back to the `main.tf` file in the webserver module (`modules/services/webserver-cluster/main.tf`) and change the code for templating the user data, like this:

```
data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = var.server_port
    db_address  = var.db_address
    db_port     = var.db_port
  }
}
```

And lastly, you need to send the variables Terragrunt is collecting from the database state to the webserver module. So edit the `main.tf` file from the webserver implementation (`stage/services/webserver-cluster/main.tf`) to something like this:

```
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = var.cluster_name
  db_address   = var.db_address
  db_port      = var.db_port

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}
```

Finally, run the `terragrunt apply` command, and if you did all the changes correctly, you should see no errors but a confirmation from Terrafrom to create the webserver resources. If you find a problem, the errors you get should be telling you where the problem is. If you get stucked, ask for help but try to fix the problems by yourself first.

## Refactor the PROD environment
Create (if you haven't done it yet) the same files you created for the stage environment but this time for the prod environment. All files should be the same, unless you want to configure a different password for the database. 

This is the list of problems you might need to fix:

* Duplicate providers or backends. 
* Reference to local modules instead of the ones from GitHub. 
* Missing `database.tfvars` file with the database password too.
* Not removing the database state bucket and key variables.
* Not including the `dependency` resource in the webserver implementation.
* Not sending the address and port variables to the module.
* Not delcaring the address and port varibles in the webserver implementation.

Then, you can go to root directory and instead of running the command to only that environment, you could do something like this:

```
terragrunt run-all apply
```

The above command will only create the prod resources because it should detect that you created the resources for the stage environment already.

## Cleanup
To remove all the resources, simply run this command in the root directory:

```
terragrunt run-all destroy
```

For reasons unknowns, Terragrunt is still asking you for the `db_password` when destroying the resources. It might be because an updated version of Terraform. But if you see that the CLI asks you for the password, provide it and Terraform will continue. This shouldn't be how Terragrunt works, but as I said before, there might be an issue whith the recent versions of Terraform.
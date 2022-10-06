# Exercise #5: Terragrunt & Environments (30m)
Before you start, make sure you've deleted the infrastructure from the previous exercise.

Let's do one final refactor to our code. As I've been saying all the time, the idea should be to create reusable modules, and everything should be a module. We're going to take this to an extreme using Terragrunt.

A good practice is to have all the modules in a GitHub repository, but for simplicity, we'll continue using the local files. Also, you might want to use different Git repositories for each module to avoid conflicts and generate new tags without affecting other modules.

So, let's suppose that  you decide to have all the modules in a Git repository. To keep things clean, you should have a separate repository for all the "live" configurations. This new repository will continue using the same folder structure but instead of having a bunch of .tf files, each implementation will have only one .hcl file.

Create a new folder called `live`, and move there the folders for the environments (`prod` and `stage`). Remove all files from the child directories and leave an empty `terragrunt.hcl` file. I'll tell you what should be the content in each folder. So far, the refactor in the folder structure should look like this:

```
├── live
│   ├── prod
│   │   ├── services
│   │   │   └── webserver-cluster
│   │   │       └── terragrunt.hcl
│   │   ├── data-stores
│   │   │   └── mysql
│   │   │       └── terragrunt.hcl
│   │   │       └── database.tfvars
│   ├── stage
│   │   ├── services
│   │   │   └── webserver-cluster
│   │   │       └── terragrunt.hcl
│   │   ├── data-stores
│   │   │   └── mysql
│   │   │       └── terragrunt.hcl
│   │   │       └── database.tfvars
│   ├── terragrunt.hcl
├── modules
│   ├── services
│   │   ├── databse
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │   ├── webserver-cluster
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       ├── user-data.sh
```

Let me show you which content should be in the stage environment, then you'll replicate for the prod environment. Let's start with the one for the database, the content for the `live/stage/data-stores/mysql/terragrunt.hcl` file should be this:

```
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/services//database"
}

inputs = {
  db_name     = "tfstagedb"
}
```

Notice how you're simply referencing the module and including the input variables (as you'd do with the `variables.tf` file). You also need to have the `database.tfvars` file with the same content as before:

```
db_password = "P4ssw0rd"
```

You can give it a try and run the apply command in this folder, just to make sure that everything is still working:

```
terragrunt apply
```

Now it's time to modify the webserver implementation, let's update the `live/stage/services/webserver-cluster/terragrunt.hcl` file with the following content:

```
include {
  path = find_in_parent_folders()
}

dependency "rds" {
  config_path = "../../data-stores/mysql"
}

terraform {
  source = "../../../../modules/services//webserver-cluster"
}

inputs = {
  db_address = dependency.rds.outputs.address
  db_port = dependency.rds.outputs.port
  
  cluster_name  = "tf-stage-cluster"
  instance_type = "m4.large"
  min_size      = 5
  max_size      = 10
}
```

Notice that the files looks similar as the one for the database. Also, you're still including the `dependency` resource and adding the input variables you need. This is what I meant by simply using a module and having configuration values for each environment. This way, you decouple the different configurations for each environment from the infrastructure code in the modules. You can continue developing the modules and apply the updates by simply referencing to the tag you want to have for each environment.

Finally, let's do the same for the PROD environment. It should be as easy as copy/paste and change the values for prod (like removing the word `stage`) to avoid conflicts.

Let your instructor know when you've recreated the infrastructure for both environments.
# Exercise #2: Refactoring into Modules (30m)
So far, we've been creating modules and we understand the benefits. But what about when you need to apply all these principles and start refactoring the code? Well, that's when we really see the power of modules. In this exercise the idea is to simulate what would happen when you're working with a legacy infrastructure and you need to refactor the IaC in Terraform.

So, let's start by creating the infrastructure as it is right now, a Terralith.

You need to create the database first which is defined in a separate Terraform template:

```
cd database
terraform init
terraform apply
```

Now you need to create the webserver which is defined in a separate Terraform template too:

```
cd ..
cd webserver
terraform init
terraform apply
```

You should have your database and webserver created, this step is just to make sure that everything works before you start refactoring the Terralith into reusable modules.

## Convert to Modules: Add Variables and Outputs
Before you continue, you need to make sure that you don't have hard coded values in the existing templates.

To help you on that, here's the list of things you need to refactor:

- Add a variable for the AMI
- Add a variable for the cluster name
- Add a variable for the database remote state bucket and key
- Add a variable for the server port
- Add a variable to configure the min and max size of the ASG
- Expose the ALB name, ASG name, and the Security Group ID through outputs

The real test that you did everything good is when you reuse the modules for different environments. So make sure you don't have any hard coded values in the templates and you're using variables instead.

## Use Modules and Add Environments
Let's assume that you've refactored the template and now it's ready to be used as modules.

You need to create two environments: test and prod. For this, simply create two folders and in each folder you need to have a `main.tf` file that uses the database and webserver module. You need to create the infrastructure for each environment. As I said before, this is going to be the real test that you've refactored the code correctly and that you're using modules in a proper way.

Your folder structure should look something like this:

```
- /modules
-- /database
-- /webserver
- /live
-- /test
---- main.tf
-- /prod
---- main.tf
```
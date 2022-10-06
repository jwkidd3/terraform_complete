# Exercise #7: Manipulating State (30m)
In this exercise you're going to practice how to manipulate the Terraform state even if it's in a local file or in a remote location like S3. There are going to be times when you need to change name of a resource or you want to decouple a big template into smaller templates. So, instead of manipulating the Terraform state file, you'll learn which commands you can use to do typical tasks that you'll find as your templates get bigger.

Let's get started with a simple one.

## Change name of a resource
One of the most common tasks you'll need to perform is to change name to Terraform resources. In this case, instead of deleting a resource and create it again, let's see how we can do a refactor by moving resources in the Terraform state. Notice that this time we're focusing only on the resource names that you have in a template. Why would you need to do this? Well, we're talking about code, and perhaps changing tag names won't do any harm, you might want to have a clean convention in your templates. Take note that there might things that you can't change withour recreating, but that would depend more on the cloud provider than Terraform (like the name of a security group).

Anyway, let's suppose that you're working with the existing `main.tf` file in this directory. Start by initiating the state and applying the template to create the resources:

```
terraform init
terraform apply --var=student_alias=[student-alias] -auto-approve
```

Now let's say that you would like to change the name of the resource from `key_service_main` to `key_service_principal`. To do so and avoid any changes in AWS, do this:

```
terraform state mv aws_key_pair.key_service_main aws_key_pair.key_service_principal
```

Then, change the name of the resource in the template too:

```
resource "aws_key_pair" "key_service_principal" {
  key_name   = "service-main-di-${var.student_alias}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 ${var.student_alias}+di@rockholla.org"
}
```

To confirm that you've done a rename successfully, run a plan:

```
terraform plan --var=student_alias=[student-alias]
```

You should see no changes pending to apply:

```
No changes. Your infrastructure matches the configuration.
```

Clean up by doing a destroy:

```
terraform destroy --var=student_alias=[student-alias] -auto-approve
```

## Move a resource into a module
Let's start by adding the definition of a security group in the root `main.tf` file:

```
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls-${var.student_alias}"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls-${var.student_alias}"
  }
}
```

Create the initial version of the infrastructure:

```
terraform init
terraform apply --var=student_alias=[student-alias] -auto-approve
```

Let's say that you regret of adding the security group in the root `main.tf` file like that and now you want to use a module. First, let's move things in the state:

```
terraform state mv aws_security_group.allow_tls module.allow_tls.aws_security_group.allow_tls
```

Let's move the `aws_security_group.allow_tls` to a new module. Create a new folder `modulea` and within that folder create a `main.tf` file with the resource definition for `aws_security_group.allow_tls` you had in the root `main.tf` file. Then, update your root `main.tf` file with the following content to use the new module:

```
module "allow_tls" {
  source        = "./modulea"
  student_alias = var.student_alias
}
```

Now you should run the `init` command again, and when you run a `plan`, you should see no pending changes:

```
terraform init --reconfigure
terraform plan --var=student_alias=[student-alias]
```

If no changes are detected, it means that your refactoring worked correctly :) ... no need to destroy yet.

## Move a resource to a new state file
Let's try another trick. If at some point you see that a resource definition should be part of a module (or template), you can move it to another place. For instance, move the resource to another state file. You don't want to recreate the resource, you simply want to do some refactor and move the definition somewhere else.

Let's suppose that we don't like to have the security group definition in the root `main.tf` file. So, let's move it to a different module, like `moduleb` in this directory. But before you start moving things, let's create the resources that are defined in `moduleb`:

```
cd moduleb
terraform init
terraform apply --var=student_alias=[student-alias] -auto-approve
```

Go back to the root directory, and move the security group resource to the `moduleb` state file:

```
terraform state mv -state-out='./moduleb/terraform.tfstate' module.allow_tls.aws_security_group.allow_tls module.allow_tls.aws_security_group.allow_tls
```

Update the config by moving the resource definition from the root `main.tf` file to the `moduleb/main.tf` file:

```
module "allow_tls" {
  source        = "../modulea"
  student_alias = var.student_alias
}
```

When you run a `plan` in both directories, you should see no pending changes:

```
terraform init --reconfigure
terraform plan --var=student_alias=[student-alias]
```

You've moved a resource from one state file to another one, congrats!

## Move a resource to a new remote state file
Let's give it a try to one final trick by moving a resource to a module that has a remote state in S3.

Once again, let's keep moving the security group to another module and then we'll move the pair key we have in the root template. We're doing this because I want you to give it a try how it's to move a resource to an empty remote state file and how to do it to an existing remote state file.

### Move to an empty state
We want to start by moving the `allow_tls` security group from `moduleb` to `modulec`, so make sure you're in the `moduleb` directory and then run the `state mv` command:

```
terraform state mv -state-out=../modulec/terraform.tfstate module.allow_tls module.allow_tls
```

Go back to the `modulec` folder, and update the `main.tf` file:

```
module "allow_tls" {
  source        = "./../modulea"
  student_alias = var.student_alias
}
```

Run the `init` command in the `modulec` folder, you'll need to confirm that you want to migrate the state to S3:

```
terraform init -backend-config=./backend.tfvars -backend-config=bucket=terraform-di-[student-alias]
```

Now remove the local state files, just to make sure you're really using now the remote state backend:

```
rm -f terraform.tfstate
rm -f terraform.tfstate.backup
```

When you run a `plan`, you should see that the only pending change is the key par defined in this module, nothing else:

```
terraform plan --var=student_alias=[student-alias]
```

If you saw that only the key pair is going to be created, let's `apply` it:

```
terraform apply --var=student_alias=[student-alias] -auto-approve
```

Everything should be working, so let's move on to the next and final task.

### Move to a non empty state
We're certain now that `modulec` is using a remote state backend, so there's no local state file that you can use to move a resource there. How do you move a resource when you're using a remote backend then? Well, you first need to download, or `pull`, the remote state:

```
cd ../modulec
terraform state pull > terraform.tfstate
```

Go back to the root folder, and create the resources if you've deleted them before, just to make sure that the resources exist and that you won't create any resource when moving it to `modulec`:

```
cd ..
terraform init
terraform apply --var=student_alias=[student-alias] -auto-approve
```

Now let's move the `aws_key_pair.key_service_principal` resource to `modulec`:

```
terraform state mv -state-out=../modulec/terraform.tfstate aws_key_pair.key_service_principal aws_key_pair.key_service_principal
```

And let's also update the `modulec/main.tf` file with the key par configuration:

```
resource "aws_key_pair" "key_service_principal" {
  key_name   = "service-main-di-${var.student_alias}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 ${var.student_alias}+di@rockholla.org"
}
```

Make sure you're now in the `modulec` folder, and push the local state to the remote backend:

```
terraform state push terraform.tfstate
```

Remove the local `terraform.tfstate` file, then run a plan:

```
rm -f terraform.tfstate
terraform plan --var=student_alias=[student-alias]
```

You should see no changes pending to apply.
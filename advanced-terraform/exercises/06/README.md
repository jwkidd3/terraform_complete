# Exercise #6: Makefile & Terraform (25m)
Let's create a simple Makefile to wrap some Terraform commands so that we can simplify the provisioning process to a single command like `make build`. Here's the list of commands that you need to wrap into a Makefile:

```
AWS_PROFILE=${AWS_PROFILE} terraform get
AWS_PROFILE=${AWS_PROFILE} terraform init -backend=true -backend-config="bucket=target-bucket" -backend-config="key=bucket-key.tfstate" -backend-config="region=${AWS_DEFAULT_REGION}"
AWS_PROFILE=${AWS_PROFILE} terraform plan -var-file=../../prod/prod.tfvars -var-file=../../common.tfvars
AWS_PROFILE=${AWS_PROFILE} terraform apply -var-file=../../prod/prod.tfvars -var-file=../../common.tfvars
AWS_PROFILE=${AWS_PROFILE} terraform output -json
AWS_PROFILE=${AWS_PROFILE} terraform destroy -var-file=../../prod/prod.tfvars -var-file=../../common.tfvars
```

Your Makefile should have the following:

* A default `all` target that should simply depend on the `plan` target
* Transform each of the above commands into a target in Makefile language
* Make use of variables to avoid repetition and make things easier to change in the future
* You need to have a target that will be used as a pre-requiste for all previous targets that needs to check if the `AWS_PROFILE` and `AWS_DEFAULT_REGION` environment variables are set, otherwise print a message so that the user understand what's missing

Below are a few examples in Makefile that will help you to build your solution.

Good Luck!

## Declaring and using variables

```
x = dude

all:
    echo $(x)
    echo ${x}
```

## Validating that a variable exist

```
bar =
foo = $(bar)

all:
ifdef foo
    echo "foo is defined"
endif
ifdef bar
    echo "but bar is not"
endif
```

In your case, you need to modify the above code snippet to validate an environment variable instead of a local variable.
# Exercise #4: How to Query the State

Terraform's state is the way in which it is able to keep a cache of infrastructure configuration and its
mapping to terraform objects.  The state is used to store information that is generated by the actual resulting
infrastructure.  An example of this would be EC2 instances, where the essential config is stored in the tf 
configuration files, but the instance ID has to be generated by AWS.  After AWS generates this ID, Terraform 
would record this information in the state.

There are many reasons why you would want to query a state for information, either via CLI or using Terraform's 
interpolation.  We will experiment with 3 ways this can be done.

### Launch Infrastructure

```bash
terraform init
terraform apply
```

(Have you saved yourself from having to worry about your student alias as a variable again yet?)

### Command Line

Terraform has a CLI command called "show", which allows users to export useful information from the state in a way 
that can be easily grep'ed or awk'ed.

```bash
terraform show
```

You should see something like this below:

```
# aws_s3_bucket_object.user_student_alias_object: 
resource "aws_s3_bucket_object" "user_student_alias_object" {
    acl           = "private"
    bucket        = "dws-di-..."
    content       = "This bucket is reserved for ..."
    content_type  = "binary/octet-stream"
    etag          = "94e32327b8007fa215f3a9edbda7f68c"
    id            = "student.alias"
    key           = "student.alias"
    storage_class = "STANDARD"
}

# data.terraform_remote_state.other_project: 
data "terraform_remote_state" "other_project" {
    backend   = "local"
    config    = {
        path = "other_project/terraform.tfstate"
    }
    outputs   = {
        bucket_name = "blep-20190110063357193700000001"
    }
    workspace = "default"
}


Outputs:

other_project_bucket = "blep-20190110063357193700000001"
```

Maybe even more helpful, Terraform also supports outputting state in a more machine-readable way:

```bash
terraform show -json
```

Terraform stores state as json, so this is mostly just returning a very similar structure and set of values that you 
might find in your `terraform.tfstate` file as well, assuming you're using local state.

### Remote State Data Type

State is not always stored in a file local to the config. If you have another project's state file accessible, you can 
use the remote state data type to parse remote state with interpolation like everything else.  Within this directory,
there is  a folder called `other_project`.  This folder contains a Terraform project that has already generated resources,
and so it has a populated tfstate file for us to reference.  If you run the following in the current directory, you will
get an output from the statefile in `other_project`, not the bucket created by this project.

```bash
terraform output other_project_bucket
```

If you got "blep-20190110063357193700000001" then this worked successfully. Take some time you look at the usage of the 
remote_state data resource and how it's implemented in this exercise and play around with it a bit. Are you able to 
create another project and get outputs from that project?

### Direct JSON Parse

Since the tfstate files are just JSON files, given the appropriate level of motivation, you could parse it directly to
get the information you need. We don't really consider this a feature of Terraform, but rather a side-effect of the way
state files exist, so we won't be doing that in this exercise.

### Finishing this exercise

Let's run the following to finish:

```bash
terraform destroy
```

# Exercise 12: Security with Terrascan (30m)
We've seen previously that Terraform has the ability to hide sensitive values from the output when you run commands. However, all the data in the state file will always be stored as clean text because of how Terraform compares what's created with what you have defined in your HCL code. Therefore, simply using the `sensitive` parameter is not going to be enough. You need to protect your state file, make sure that at least you have encryption at-rest enabled in a remote backend like S3.

In this exercise, we'll go one step further by using Terrascan to analyze your HCL code, even before you commit your changes to source control. After this, you can take the same learnings and include Terrascan in your CD pipelines.

So, let's get started.

## Set Up
For starters, you need to have Python installed (if you have it already, skip to the next paragraph to install the `pre-commit` tool). Here's one way to do it by running the following command:

```
curl https://pyenv.run | bash
```

I'm assuming that you'll be using Python 3, so once you have confirmed that you have it available in your workstation, run the following command to install the `pre-commit` tool to run commands before you commit your code:

```
pip3 install pre-commit
```

Finally, it's time to install Terrascan, if you're using a Mac simply run this:

```
brew install terrascan
```

If you're using a different OS, look at the [instructions on how to install it](https://terrascan.readthedocs.io/en/latest/installation.html).

## Configure Pre-Commit Hook
Once you have the `pre-commit` tool installed, let's use it. Start by creating a new folder for your code, then initialize the Git repo, and go to that folder. Here are the commands you need to run:

```
mkdir security-example
git init security-example
cd security-example
```

In the root directory, create a `.pre-commit-config.yaml` (exact name, including the `.` as a prefix) file with the following exact content:

```
repos:
-   repo: https://github.com/antonbabenko/pre-commit-terraform
    sha: v1.50.0
    hooks:
    -   id: terrascan
```

Now run the following command to install the `pre-commit` tool you specified in the file you created before. Just run this command:

```
pre-commit install
```

You should be ready now to give it a try.

Create a `main.tf` file with the following content, noticed that the HCL code will try to create a typical S3 bucket but we'll use Terrascan to find out if it's secure or not. If it's not secure, don't commit. So, here's the code:

```
variable "bucket" {}

resource "aws_s3_bucket_object" "html" {
  bucket   	= var.bucket
  key      	= "index.html"
  source   	= "index.html"
  acl      	= "public-read"
  content_type  = "text/html"
  etag     	= filemd5("index.html")
}
```

Let's try to do a commit in the repository, like this:

```
git add . && git commit -m 'Genesis'
```

If everything is working correctly, you should see an error like this:

```
terrascan................................................................Failed
- hook id: terrascan
- exit code: 3

Violation Details -
    
        Description    :        Ensure S3 object is Encrypted
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        3
        Severity       :        MEDIUM
        -----------------------------------------------------------------------
```

Great! It works! Now is time to fix it.

Improve the security of the resource, you can give it a look at the [Terraform official docs on how to enable encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object).

When you fix the error, you should be able to continue with the commit.

```
git add . && git commit -m 'Genesis'
```

Then, you should see a message like this:

```
terrascan................................................................Passed
[master (root-commit) 701a3dd] Genesis
 2 files changed, 22 insertions(+)
 create mode 100644 .pre-commit-config.yaml
 create mode 100644 main.tf
```

If you want to give it a try to Terrascan with any previous code we've used so far, go ahead and let your instructor know your findings. For now, let your instructor know that you're done with this exercise and while you wait for the rest of students to finish, keep playing with this tool.
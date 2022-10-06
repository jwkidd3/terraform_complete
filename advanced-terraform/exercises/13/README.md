# Exercise 13: Terraform in Pipelines (30m)
It's time to put in practice what you've learned about doing Continous Delivery when using Terraform.

In this exercise you'll be able to play with Atlantis and how it can be integrated when doing a merge request or adding comments when doing a code review. Then, you'll be practicing pushing new changes in your HCL code automatically to AWS by configuring a CI/CD pipeline in GitLab.

Let's get into it.

## Configuring Atlantis
Let's start by configuring Atlantis in our Git repository so that every time we create a merge request and add a comment, we can review the changes and run a plan. I'm going to give you a Terraform template that you can use to provision an EC2 instance with Atlantis installed and configured. In this section we're simply going to confirm that Atlantis is working and that we can run Terraform commands from a comment. If you want to continue using Atlantis for testing how it works when creating real infrastructure in AWS you might need to change the existing template I'm providing. For instance, to create resources in AWS remember that you need to provide credentials, and this template doens't have that yet. You either configure the instance to use a set of secret and access keys or an IAM role (recommended).

We're going to use GitLab, but you should have no problems adapting the following steps to GitHub or BitBucket.

So, let's start by creating a repository in GitLab. Now, create a personal access token, you can [follow the official guide on how to do it](https://docs.gitlab.com/ce/user/profile/personal_access_tokens.html#create-a-personal-access-token). **You need to create the token with the API scope only**. Copy the token generated as we'll use it in a moment to configure the Terraform template.

Let's create now a random secret to protect the communication between GitLab and Atlantis. [[You can use a random site generator](https://www.random.org/strings/) or any other value that you want. Again, we'll use this secret in a moment.

Head over to the `atlantis` folder:

```
cd atlantis
```

You now need to create a `terraform.tfvars` with the following variables and content:

```
username       = "YOUR_GITLAB_USERNAME"
token          = "YOUR_GITLAB_PERSONAL_TOKEN"
secret         = "YOUR_RANDOM_SECRET"
git_host       = "gitlab.com"
repository     = "YOUR_GITLAB_REPOSITORY_NAME"
```

Once you have the proper values, you can run the following Terraform commands to provision the Atlantis instance:

```
terraform init
terraform apply
```

When the Atlantis instance is ready, you should see an output like this:

```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

atlantis-dns = "ec2-54-193-177-59.us-west-1.compute.amazonaws.com"
atlantis-url = "http://ec2-54-193-177-59.us-west-1.compute.amazonaws.com:4141"
```

You can open the `atlantis-url` in a browser to confirm that Atlantis is working.

Terraform stores the PEM key locally that you'll need in case you want to SSH into the instance, you'll need to run the following commands to connect remotely to the instance:

```
chmod 400 atlantis.pem
ssh -i atlantis.pem ubuntu@$(terraform output -raw atlantis-dns)
```

## Configuring GitLab to use Atlantis
Head over your GitLab repository, and in the left panel click on `Settings -> Webhooks` to see the Webhooks settings. In this window, use the `atlantis-url` you got from Terraform and put it in the `URL` field, but make sure you include the `/events` at the end, like this `http://ec2-54-193-177-59.us-west-1.compute.amazonaws.com:4141/events`.

Then, check the `Push events`, `Comments`, and `Merge Requests events`. Scroll down a little bit and make sure that the `Enable SSL verfication` **is not checked** as we're not using the HTTPS protocol (you might want to use it when configuring a production environment). Finally, click on the `Add webhook` blue button.

Scroll down, at the bottom of the screen you should see the Webhook you just created. Click on the `Test` button and choose `Push events`. A pop up message should appear saying that the test ran susccessfully (with a 200 code). If you got this, you've configured Atlantis in GitLab successfully. Let's give it a try.

## Using Atlantis in GitLab

In the left panel, click on `Repository`. Then, click in the `+` button and instead of creating a new file, let's create a new branch and call it something like `feature-1`. In this branch, create a new `main.tf` file with the following content:

```
resource "null_resource" "example" {}
```

Then, in the left panel, click on `Merge requests` and generate a new one to integrate the code you just added in the `dev` branch to the `main` branch. Atlantis will listen to this request, and will run a pipeline to confirm that the code will work. You can click on the `CI/CD -> Pipelines` in the left panel to confirm it.

Go back to the `Merge requests` page, you should see the one you just created before. Open it, and add a comment with the following content:

```
atlantis plan
```

Wait for a few seconds, and you should see that Atlantis adds a new comment with the result of the Terraform plan.

And that's it, this is how you'll use Atlantis to review the code in a Git repository before it gets merged into the `main` branch.

## GitLab Pipelines
Let's use an existing template that simply defines an EC2 instance with a few other things. We'll use the code that exist already in the `cicd` folder of this directory.

Go back to GitLab, to the repository you created previously and let's clone it (if you haven't already), like this:

```
git clone git@gitlab.com:christianhxc/di-tf-advanced.git
```

Copy the code from the `cicd` folder to the location where you cloned the repository.

Let's add, commit, and push the existing code:

```
git add .
git commit -m "Alpha version"
gir push origin main
```

Now that the code is in Git, let's configure the pipeline. Go to `Settings -> CI/CD`, then to the `Variables` section and add the AWS credentials that Terraform will use to provision resources, here is the list of variable names that Terraform will expect:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

Create a `.gitlab-ci.yml` in the root folder of the repository you just cloned with the following content:

```
image:
  name: hashicorp/terraform:light
  entrypoint:
    - '/usr/bin/env'
    - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

before_script:
  - rm -rf .terraform
  - terraform --version
  - export AWS_ACCESS_KEY_ID
  - export AWS_SECRET_ACCESS_KEY
  - terraform init

stages:
  - validate
  - plan
  - apply

validate:
  stage: validate
  script:
    - terraform validate

plan:
  stage: plan
  script:
    - terraform plan -out "planfile"
  dependencies:
    - validate
  artifacts:
    paths:
      - planfile

apply:
  stage: apply
  script:
    - terraform apply -input=false "planfile"
  dependencies:
    - plan
  when: manual
```

A few important things to highlight here:

* We'll use a Docker image that has Terraform installed already
* We'll remove any existing Terraform file, export the AWS credentials environment varialbes and run the `terraform init` command before the pipeline even starts
* We declare which stages the pipeline will have
* The `apply` stage has a parameter `manual` so that we're the ones approving the creation of resources

Now let's add the `.gitlab-ci.yml` file to the repository:

```
git add .
git commit -m "Added the CI/CD pipeline definition"
git push origin main
```

Head over to your GitLab repository, and click on the `CI/CD` pipelines and explore the logs to see what the pipeline is doing. Then, when the `validate` and `plan` stages finish, the pipeline should be paused in the final `apply` stage waiting for you to "approve" it. Click on the play button, and the pipeline should continue. If everything finished successfully, you should see the instance in AWS.

As a final test, let's change some text in the `user-data.sh` script and push it. Wait for the pipeline to finish, approve it, and you should see the new change deployed automatically. This is a basic template and a basic workflow, but this should be the workflow you should be following from now on.

Let your instructor know when you're done.
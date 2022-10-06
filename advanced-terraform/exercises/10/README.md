# Exercise #10: Zero-Downtime Deployment (25m)
Let's give it a try to how you can do a deployment with zero downtime in AWS using Terraform. The purpose of this exercise is that you experience how you need to implement things in Terraform and how the workflow would be when you decide not do changes in the AWS console anymore.

We'll keep things simple in this exercise, but it will take a some time for you to see the complete workflow.

So, let's use an existing HCL code. Do the following, and let your instructor know when you're done:

* Deploy the project as it is now, don't change anything yet
* When Terraform finishes, confirm that the application is working by querying the ALB DNS
* Make a small change in the `user-data.sh` script to change the output, and run a `terraform plan`

Notice how Terraform will try to destroy the launch configuration (LC), create a new one, and update the ASG to use the new LC. There's nothing wrong with this approach, at least at this point, but if you want to see a new change you have to deregister the instance or scale out the ASG to add a new server. You can do this in Terraform, but it will require too many steps for every time you want to make a new deployment.

## Configure the Zero-Downtime Deployment
A better approach would be to use life-cycle hooks in Terraform to create a resource before destroying it (just in case it fails). And also, we can say to Terraform to create a new ASG every time we create a new LC. Finally, configure the ASG to register its instances to the ALB once there's enough capacity and it's healthy.

Before you do any change, here's a code snippet of the things you might need:

```
  lifecycle {
    create_before_destroy = true
  }
```

You'll also need to change the `min_elb_capacity` and the `name` of the ASG resource to change every time the LC changes.

So, do the following to configure the zero-downtime deployment:

* Change the name of the ASG to depend directly on the name of the LC
* Configure the `create_before_destroy` parameter to avoid destroying any existing ASG before the new one is ready
* Set a number for the `min_elb_capacity` to say that Terraform waits for the new ASG to be ready before it starts receiving traffic

When you're done, deploy it, and wait for it to be ready (if we don't have too much time, don't deploy it yet and continue with the following section)

## Make a new Change and Test It!
Finally, this would be the third time we make a deployment (if time allowed).

Change something in the `user-data.sh` script and deploy the change with Terraform.

Open a new terminal, and leave the `testing.sh` running. This will act as a monitor so that you can see that there's now downtime while Terraform does the deployment. You can also go to the AWS console to monitor how every change is being done.

When you've confirmed that you were able to do a zero-downtime deployment, let your instructor know and delete all the resources created.
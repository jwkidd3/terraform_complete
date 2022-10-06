# Exercise #3: Module Versioning (30m)
Let's continue improving our code, and for this you'll continue using the same template files you created previoiusly. The only difference this time is that you need to create a GitHub repository (or any Git server if you don't have access to/can't use GitHub). Then, you simply need to change the references to this modules.

Your module usage now should look something similar to this:

```
module "webserver_cluster" {

  source = "github.com/christianhxc/tf-adv-database//src?ref=v0.1.0"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
}
```

So, in summary, you need to do the following:

- Use the code from the previous exercise
- Create a new GitHub repository for each module
- Change the references to the GitHub URL instead of a local folder

You could either destroy and create the infrastructure again to confirm that everything is working or create a new environment like `dev` or `stage`.
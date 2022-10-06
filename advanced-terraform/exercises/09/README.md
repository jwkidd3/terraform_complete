# Exercise #9: Conditionals in Terraform (30m)
Let's improve a little bit the database module we've been using so far.

You can find one version of thad module in this directory under the `database` folder. Use this module for the following tasks. The idea is that you can have the option to create or not the database when using it as a module. Also, a developer might find useful to have a connection string example as the output.

So, for this exercise, do the following for the `database` module:

* Include a variable named `create_database` and use it as a conditional to create the database within the module (use `count`)
* Configure the module to skip the final snapshot only if it's a `t2` instance type (use the [format](https://www.terraform.io/docs/language/functions/format.html) or [substr](https://www.terraform.io/docs/language/functions/substr.html) functions to extract a string to then compare)
* Add an output for a connection string in .NET only if the instance type it's a `t2` (You need to use an `if` within the string, like this `"Hello, %{if var.name != ""}${var.name}%{else}(null)%{endif}"`). Here's an example of the connection string: `Server=DB_HOST;Database=DB_NAME;Uid=DB_USERNAME;Pwd=DB_PASSWORD;`. You can take all the values (except the password) from the `Attributes Reference` section from the [official docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance).

**IMPORTANT NOTE:** Make sure you test the option of not creating the database, you shouldn't have any errors. **Hint:** You'll have errors if you don't run some validations in the output.
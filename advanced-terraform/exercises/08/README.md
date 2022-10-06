# Exercise #8: Looping in Terraform (30m)
It's to practice looping in your HCL files. We've seen in class different ways that Terraform has for looping, but in this case we're going to practice only the two most common approaches you'll use. If you need to check the examples for the other options we saw in class, you can find them in the examples directory of this repository.

Let's get started.

## Using count
The first approach to practice is by using the `count` meta-argument. Below is an example of the syntax and how to use it. You'll need to adapt it based on the tasks I've assigned to you in this exercise. Make sure you understand the below example:

```
resource "aws_instance" "server" {
  count = 4 # create four similar EC2 instances

  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}
```

Now, your tasks are going to be:

* Create one bastion host for three of your developers: John, Paul, and Mindy
* Make sure each instance has a different name (use the `Name` tag)
* Loop through a variable to keep clean code (use the `length` function too)
* Output the public or private IP of all instances (find out which key to use from the *.tfstate)

Remember that you can use string interpolations using the `count.index`, like this:

```
name = "bastion-${var.users[count.index]}"
```

And you can do it in the outputs as well, like this:

```
output "all_keys" {
  value = aws_key_pair.keys[*].id
}
```

## Using for_each
As an alternative to the `count` approach, it's recommended to always use the `for_each` meta-argument for the reasons we discussed in class. The main reason is that when you decide to delete an element, thus reducing the number of resources you want to have, the `count` approach will destroy resrouces just for the sake of moving a resource to a different index location. This doesn't happen when you use the `for_each` approach.

So, before dive into the taks for this section, here's an example of the syntax and how to use the `for_each` argument:

```
resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}
```

Now, your tasks are going to be:

* Refactor the code you use in the previous section and use `for_each` instead of `count`
* Create a security group for each user where you define dynamically the ingress rules
* Assign the security group for a user to its corresponding instance
* Define a variable of type map to define the list of ports and CIDRs you're going to allow in the SG
* Create an output where you can list the IDs for each SG

Just in case you need it, here's an example of a SG in Terraform:

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
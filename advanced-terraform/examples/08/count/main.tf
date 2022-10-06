## Loops - Count

resource "aws_key_pair" "keys" {
  count = 3 // length(var.users)
  // avoid having the same name with ${count.index} or ${var.users[count.index]}
  key_name   = "loop-di"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 di@rockholla.org"
}

variable "users" {
  type    = list(string)
  default = ["john", "paul", "mindy"]
  // TRY: What happens when you delete "paul"? Why it tries to create/destroy? 
  // ==> Terraform identifies each resource by its position, mindy needs to be moved to index 1
  //     it would be better to use for_each to avoid Terraform removing resources
}

output "key" {
  value = aws_key_pair.keys[0].id
}

output "all_keys" {
  value = aws_key_pair.keys[*].id
}
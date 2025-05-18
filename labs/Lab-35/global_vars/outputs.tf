#-------------------------------------------------------------------------------
#  Terraform  
#
#  Place here all your Global Variable as outputs
#  and just call this module from your code
#
#  
#-------------------------------------------------------------------------------

output "tags" {
  value = {
    Project = "Phonix"
    Manager = "Denis A"
    Country = "Canada"
  }
}

output "prod_server_size" {
  value = "t3.medium"
}

output "staging_server_size" {
  value = "t3.micro"
}

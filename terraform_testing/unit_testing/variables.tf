### AWS KEYS
### Key vaules are stored within terraform.tfvars file which should be in your gitignore.



### VPC RELATED VARIABLES
variable "region" {
  default     = "us-east-1"
  description = "region that the VPC and other network components should be deployed into."
}

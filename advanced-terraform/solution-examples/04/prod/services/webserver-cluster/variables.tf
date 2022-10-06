variable "db_address" {}

variable "db_port" {}

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-prod"
}

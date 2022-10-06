variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_prod"
}

variable "instance_type" {
  default = "db.t2.micro"
}

variable "create_database" {
  type = bool
}
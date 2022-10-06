variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  default     = "tf-cluster"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  default     = "t2.micro"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  default     = 1
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  default     = 3
  type        = number
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  default     = true
  type        = bool
}

variable "ami" {
  description = "The AMI to run in the cluster"
  default     = "ami-0d382e80be7ffdae5"
  type        = string
}

variable "server_text" {
  description = "The text the web server should return"
  default     = "Hello, World"
  type        = string
}

variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
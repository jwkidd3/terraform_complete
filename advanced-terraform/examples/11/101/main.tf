variable "api_url" {
  description = "A URL that you would like to test"
  type = string
}

output "api_url" {
  value = var.api_url
}
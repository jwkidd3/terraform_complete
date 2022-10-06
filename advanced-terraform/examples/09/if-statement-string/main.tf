variable "name" {}

output "if_else_directive" {
  value = "Hello, %{if var.name != ""}${var.name}%{else}(null)%{endif}"
}
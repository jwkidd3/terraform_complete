locals {
  policy = templatefile(var.user_data_script,{server_http_port="8080",server_text="Hello Dawg!"})
}
output "test"{
    value=local.policy
}

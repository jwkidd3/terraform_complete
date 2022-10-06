output "address" {
  value       = var.create_database ? aws_db_instance.example[0].address : null
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = var.create_database ? aws_db_instance.example[0].port : null
  description = "The port the database is listening on"
}

output "connection_string" {
  value = "%{if var.create_database && format("%.5s", var.instance_type) == "db.t2"}Server=${aws_db_instance.example[0].endpoint};Database=${aws_db_instance.example[0].name};Uid=${aws_db_instance.example[0].username};Pwd=${var.db_password};%{else}(null)%{endif}"
}

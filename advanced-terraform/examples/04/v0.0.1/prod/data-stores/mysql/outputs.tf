output "address" {
  value       = module.database.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.database.port
  description = "The port the database is listening on"
}

include {
  path = find_in_parent_folders()
}

dependency "rds" {
  config_path = "../../data-stores/mysql"
}

inputs = {
  db_address = dependency.rds.outputs.address
  db_port = dependency.rds.outputs.port
}

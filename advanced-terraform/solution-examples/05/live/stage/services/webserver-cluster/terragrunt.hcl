include {
  path = find_in_parent_folders()
}

dependency "rds" {
  config_path = "../../data-stores/mysql"
}

terraform {
  source = "../../../../modules/services//webserver-cluster"
}

inputs = {
  db_address = dependency.rds.outputs.address
  db_port = dependency.rds.outputs.port
  
  cluster_name  = "tf-stage-cluster"
  instance_type = "m4.large"
  min_size      = 5
  max_size      = 10
}

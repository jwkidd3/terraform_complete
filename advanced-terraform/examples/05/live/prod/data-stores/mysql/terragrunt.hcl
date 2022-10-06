include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/services//database"
}

inputs = {
  db_name     = "tfproddb"
}
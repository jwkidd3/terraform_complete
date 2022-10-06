module "database" {
  source = "../../../modules/services/database"

  db_name     = var.db_name
  db_password = var.db_password
}

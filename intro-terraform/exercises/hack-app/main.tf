module "backend" {
  name             = "backend"
  user_data_script = "microservice/user-data/user-data-backend.tftpl"
  source           = "./microservice"
}
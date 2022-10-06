resource "aws_db_instance" "example" {
  count               = var.create_database ? 1 : 0
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = var.instance_type
  name                = var.db_name
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = format("%.5s", var.instance_type) == "db.t2" ? true : false
}

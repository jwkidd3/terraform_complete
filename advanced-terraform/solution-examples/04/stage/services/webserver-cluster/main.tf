module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = var.cluster_name
  db_address   = var.db_address
  db_port      = var.db_port

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

#-------------------------------------------------------------------------------
#  Terraform  
#
# Re-Create Resource in Terraform up to v0.15.1
#    1. terraform init
#    2. terraform taint aws_instance.node2
#    3. terraform plan
#    4. terraform apply
#  
#-------------------------------------------------------------------------------

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "node1" {
  ami           = "ami-05655c267c89566dd"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-1"
    Owner = " "
  }
}

resource "aws_instance" "node2" {
  ami           = "ami-05655c267c89566dd"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-2"
    Owner = " "
  }
}

resource "aws_instance" "node3" {
  ami           = "ami-05655c267c89566dd"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-3"
    Owner = " "
  }
  depends_on = [aws_instance.node2]
}

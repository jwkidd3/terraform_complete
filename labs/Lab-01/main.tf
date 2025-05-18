#----------------------------------------------------------
#  Terraform  
#
# Build EC2 Instances
#
#  
#----------------------------------------------------------

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-06e54d05255faf8f6" # This is Comments
  instance_type = "t3.micro"              // This is also Comments
  key_name      = "denis-key-oregon"

  tags = {
    Name    = "My-UbuntuLinux-Server"
    Owner   = " "
    project = "Phoenix"
  }
}

resource "aws_instance" "my_amazon" {
  ami           = "ami-0528a5175983e7f28" // This is Comments
  instance_type = "t3.small"              # This is also Comments

  tags = {
    Name  = "My-AmazonLinux-Server"
    Owner = " "
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "fin-mobile-frontend" {
  ami           = data.aws_ami.aws_linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Finance_Front_End",
    Cost_Center = "Finance",
    Admin_Contact = var.admin_group
  }
}

data "aws_ami" "aws_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter { 
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2",]
  } 
}



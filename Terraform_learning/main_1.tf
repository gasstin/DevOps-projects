# Credentials
variable "AWS_ACCESS_KEY_ID"{
  type = string
}

variable "AWS_SECRET_ACCESS_KEY"{
  type = string
}

variable "aws_region" {
  default = "sa-east-1"
}

terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.16"
    }
  }
}

# Configuration
provider "aws" {
  region = var.aws_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  
}

resource "aws_vpc" "learning-vpc" { # the name is important to use later
  cidr_block = "10.0.0.0/16"

    tags = {
      Name = "production"
    }  
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.learning-vpc.id # reference the subnet to the previous vpc
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Production-subnet"
  }
}
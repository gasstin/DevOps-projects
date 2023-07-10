# Credentials
variable "AWS_ACCESS_KEY_ID"{
  type = string
}

variable "AWS_SECRET_ACCESS_KEY"{
  type = string
}

variable "aws_region" {
  type = string
  default = "sa-east-1"
}

variable "subnet_list" {
  description = "A list with the diferents subnet cidr_blocks"
}

provider "aws" {
    region = var.aws_region
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"
  
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.test-vpc.id
  cidr_block = var.subnet_list[1].cidr_block

  tags = {
    Name = var.subnet_list[1].name
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.test-vpc.id
  cidr_block = var.subnet_list[0]
}
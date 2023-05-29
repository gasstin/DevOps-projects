variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "LearningInstance"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-06fce8d0a4e8889ca"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }

}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}


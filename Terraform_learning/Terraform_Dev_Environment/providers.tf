variable "aws_region" {
  description = "Set the AWS region"
  default     = "sa-east-1"

}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "gasstin_devops"
}

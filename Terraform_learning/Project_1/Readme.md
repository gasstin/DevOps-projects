# AWS Infrastructure Deployment

This repository contains Terraform code to deploy an AWS infrastructure consisting of a VPC, subnet, internet gateway, route table, security group, network interface, elastic IP, and an Ubuntu web server running Apache2.

## Prerequisites

Before running the Terraform code, make sure you have the following:

1. AWS access key and secret access key with appropriate permissions.
2. Terraform installed on your local machine.

## Usage

1. Clone this repository to your local machine.
2. Navigate to the cloned repository.
3. Update the `variables.tf` file to provide your AWS access key ID and secret access key.
4. Optionally, modify the default region in the `variables.tf` file if needed.
5. Run the following commands to deploy the infrastructure:

   ```bash
   terraform init
   terraform plan
   terraform apply

6. Use `terradorm destroy` To destroy the created infrastructure and release associated resources.
# Creating a Development Environment with Terraform in AWS

This guide will walk you through the process of setting up a development environment in AWS using Terraform. The Terraform files and templates required for this setup are included in the current directory.

## Prerequisites

Before you begin, ensure that you have the following prerequisites set up:

1. **AWS CLI**: Make sure you have the AWS Command Line Interface installed and configured with the necessary credentials to access your AWS account.

2. **Terraform**: Install Terraform on your local machine. You can download it from the official Terraform website: https://www.terraform.io/downloads.html

3. **SSH Key Pair (Optional)**: If you plan to use SSH to access your instances, make sure you have an SSH key pair created. Terraform will automatically use the default SSH key in your AWS account if you don't specify one.

## Terraform Files

The following Terraform files are included in the current directory:

1. `data_sources.tf`: This file defines any data sources that your Terraform configuration needs, such as AWS AMIs, security group information, etc.

2. `main.tf`: The main Terraform configuration file where you define the AWS resources and their configurations. This is the heart of your infrastructure definition.

3. `providers.tf`: In this file, you define the AWS provider with the necessary configuration, such as the region and credentials to be used.

4. `variables.tf`: This file is used to declare input variables for your Terraform configuration. These variables can be used to make your infrastructure flexible and reusable.

5. `terraform.tfvars`: This file contains the actual values for the variables declared in `variables.tf`. You should populate this file with your specific configurations. Remember not to commit sensitive information (e.g., passwords, API keys) to version control.

## Template Files

In addition to the Terraform files, you'll find the following template files:

1. `linux-ssh-config.tpl`: A template for configuring SSH access on Linux instances. This file will be populated with your specific SSH configuration.

2. `windows-ssh-config.tpl`: Similar to the previous one, but for Windows instances.

3. `userdata.tpl`: This template contains the user data script that will be executed on the instances during launch. Customize this template with your desired scripts and configurations.

## Getting Started

To create your development environment, follow these steps:

1. **Initialize Terraform**: Run the following command to initialize Terraform in the current directory: `terraform init`

2. **Review and Modify Variables**: Open the `terraform.tfvars` file and provide the necessary values for the variables. Make sure to set the correct AWS region, instance type, SSH key name (if applicable), etc.

3. **Plan the Infrastructure**: Run the following command to see what Terraform plans to do before actually creating any resources: `terraform plan`

4. ´**Apply the Changes**: If the plan looks good, apply the changes to create the development environment: `terraform apply`

5. **Destroy the Environment (When No Longer Needed)**: When you're done with the development environment, make sure to clean up by destroying the resources: `terraform apply`

Please note that Terraform will prompt for confirmation before executing destructive actions, such as applying or destroying the infrastructure.

## Important Notes

- Ensure that you understand the changes you are making to your AWS account. Terraform can create, modify, or delete resources, so proceed with caution.

- Do not commit sensitive information (e.g., AWS credentials, private keys) to version control. Use environment variables or other secure mechanisms to pass sensitive data to Terraform.

- Always review the Terraform plan (`terraform plan`) before applying changes to your infrastructure to avoid unintended consequences.

- Consider versioning your Terraform configurations to track changes and manage updates effectively.

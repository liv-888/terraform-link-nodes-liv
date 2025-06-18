# The Link Between the Nodes – Episode 2

## What This Project Does

This project provisions infrastructure in AWS using Terraform:

- A VPC with CIDR block 10.10.0.0/16 named cyber-vpc
- Two private subnets in eu-west-1a and eu-west-1b
- A security group that allows SSH only between the two subnets
- Two EC2 instances (t3.micro, Amazon Linux 2)
  - NodeA in Subnet A
  - NodeB in Subnet B
- No public IP addresses
- SSH access between the two instances over private IPs

## SSH Connection Test

SSH connection works between the two instances:

- NodeA to NodeB
- NodeB to NodeA

Screenshots or logs are located in the screenshots folder.

## Remote Backend

Terraform state is stored remotely using:

- An S3 bucket for the state file
- A DynamoDB table for state locking

These resources were created manually. The backend configuration is added in main.tf and terraform init was used to migrate the state.

## CloudFormation Side Quest

The same setup was created using CloudFormation.

The template file is in:

cloudformation/sidequest.yaml

It was deployed from the AWS Console using CloudFormation.

## Comparison: Terraform vs CloudFormation

Terraform is easier to write and change. It works well from the CLI and has better readability.

CloudFormation is good for fully managed stacks and easier for people who prefer the AWS Console.

## Cleanup

Resources were deleted using terraform destroy and the CloudFormation stack was deleted from the console. No charges were generated because everything used the Free Tier.

## Status

All requirements were completed successfully.

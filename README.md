# private-eks-aws-terraform
Script to setup a private k8s cluster on VPC on AWS

Terraform EKS Private Cluster Setup

This repository contains Terraform code to provision an Amazon Elastic Kubernetes Service (EKS) cluster in a private VPC with outgoing internet connectivity via a NAT Gateway. The setup includes creating a VPC, subnets, internet gateway, NAT gateway, route tables, EKS cluster, and managed node groups.
Table of Contents

    Prerequisites
    Architecture Overview
    Getting Started
        Clone the Repository
        Configure AWS Credentials
        Initialize Terraform
        Review and Customize Variables
        Apply the Terraform Configuration
    Resources Created
    Cleanup
    Next Steps
    License
    Variables
    Outputs

Prerequisites

Before you begin, ensure you have the following:

    AWS Account: An active AWS account with permissions to create resources like VPCs, IAM roles, EKS clusters, etc.
    Terraform: Installed Terraform v1.0 or later. Install Terraform
    AWS CLI: Installed AWS CLI for credential management. Install AWS CLI
    kubectl: (Optional for next steps) Installed kubectl to interact with the EKS cluster.

Architecture Overview

The Terraform code sets up the following architecture:

    VPC: A new Virtual Private Cloud with a CIDR block of 10.0.0.0/16.
    Subnets:
        Private Subnets: Two private subnets across two Availability Zones.
        Public Subnet: One public subnet for the NAT Gateway.
    Internet Gateway: Attached to the VPC for internet access in the public subnet.
    NAT Gateway: Deployed in the public subnet to provide internet access to resources in private subnets.
    Route Tables:
        Public Route Table: Routes internet traffic through the Internet Gateway.
        Private Route Table: Routes internet-bound traffic through the NAT Gateway.
    Security Groups: Security groups for the EKS cluster control plane and nodes.
    IAM Roles:
        EKS Cluster Role: Permissions for the EKS control plane.
        EKS Node Group Role: Permissions for the EC2 instances in the node group.
    EKS Cluster: Deployed in the private subnets with private endpoint access.
    Managed Node Group: Worker nodes in the private subnets.

Getting Started
Clone the Repository

Clone this repository to your local machine:

bash

git clone https://github.com/yourusername/private-k8s-aws-terraform.git
cd private-k8s-aws-terraform

Configure AWS Credentials

Ensure your AWS credentials are configured. You can set them using environment variables or AWS CLI configuration:

bash

aws configure

Alternatively, set the following environment variables:

bash

export AWS_ACCESS_KEY_ID="your_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
export AWS_DEFAULT_REGION="your_aws_region"

Initialize Terraform

Initialize the Terraform working directory to download the necessary providers:

bash

terraform init

Review and Customize Variables

Review the variables.tf file to customize any default values. Alternatively, you can create a terraform.tfvars file to override variable values.

Example terraform.tfvars:

hcl

cluster_name          = "eks-private-cluster"
aws_region            = "us-east-1"
vpc_cidr              = "10.0.0.0/16"
private_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidr    = "10.0.0.0/24"
availability_zones    = ["us-east-1a", "us-east-1b"]
node_instance_type    = "t3.medium"
desired_node_capacity = 2
max_node_capacity     = 3
min_node_capacity     = 1

Apply the Terraform Configuration

Review the plan and apply the configuration:

bash

terraform plan
terraform apply

Type yes when prompted to confirm the operation.
Resources Created

The Terraform script will create the following AWS resources:

    VPC: eks-private-vpc
    Subnets:
        Private Subnets: eks-private-subnet-1, eks-private-subnet-2
        Public Subnet: eks-public-subnet
    Internet Gateway: eks-internet-gateway
    NAT Gateway: eks-nat-gateway
    Elastic IP: For the NAT Gateway
    Route Tables:
        Public Route Table: eks-public-route-table
        Private Route Table: eks-private-route-table
    Security Groups:
        EKS Cluster Security Group
        Worker Node Security Group
    IAM Roles:
        EKS Cluster Role: eks-cluster-role
        EKS Node Group Role: eks-nodegroup-role
    EKS Cluster: eks-private-cluster
    Managed Node Group: eks-private-nodegroup

Cleanup

To delete all resources created by Terraform, run:

bash

terraform destroy

Type yes when prompted to confirm the destruction.

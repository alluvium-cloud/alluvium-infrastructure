# Alluvium Infrastructure Terraform

This repository contains the Packer and Terraform HCL definitions for Eric's Home Network and Cloud Lab.

## Modules

This repository is broken up into a set of modules that can be optionally included. 

The idea is that this repository will grow from just my home lab's Terraform to a set of modules that can be used for running live
customer-facing demos for a number of real-world use cases.

- aws_network
  - Creates a VPC in AWS with a public and private subnet (optionally multiple of each!)
  - Creates a Bastion SSH host
- hvn
  - Creates a HashiCorp Virtual Network
  - Creates a Peering relationship with the previously-built AWS VPC and accepts the Peering request
  - Configures all necessary routing
- hcp_vault
  - Creates an HCP Vault cluster in the previously configured HVN
- vpn_wireguard
  - Deploys a Wireguard instance to connect my Home network to the VPC and configures all routing

## Pre-Requisites

- Create or access an existing Terraform Cloud Organization with "Team & Governance Plan" features enabled.
- Create a Service Principal for the target Organization in portal.cloud.hashicorp.com, Access Control (IAM).
  - Capture the Client ID and Secret
- AWS
  - Create an AWS IAM User/Access Keys with the "AdministratorAccess" permission set in the target AWS account.
    - Capture the Access Key ID and Secret.
- GCP
  - Create a Service Account user with the Editor role, generate key in JSON.
    - Capture the key
- Create a Variable Set in Terraform Cloud containing the following Environment variables: 
  - HCP_CLIENT_ID
  - HCP_CLIENT_SECRET (sensitive)
  - AWS
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY (sensitive)
  - GCP
    - GOOGLE_CREDENTIALS (sensitive)
- Create the HCP-Packer Run Task in your Terraform Cloud Organization
  - Retrieve the "Endpoint URL" and "HMAC Key" from the HCP Packer / "Integrate with Terraform Cloud" page under portal.cloud.hashicorp.com

### Terraform

- Edit terraform.tf and populate the Organization and Workspace names
- terraform init
- Assign the credentials Variable Set to the workspace, unless you created the Variable Set as organization-wide
- Assign HCP Packer Run Task to Workspace
- terraform plan
- terraform apply

### Various repositories were borrowed from to construct this repository.
- https://github.com/brokedba/terraform-examples
- https://github.com/vainkop/terraform-aws-wireguard

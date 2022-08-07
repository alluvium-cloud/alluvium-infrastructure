##############################################################################
# Variables File
#
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "environment" {
  description = "This environment will be included in the name of most resources."
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
}

variable "public_subnets_dhcp_cidr" {
  type        = list(any)
  description = "CIDR block for DHCP on Public Subnet"
}

variable "private_subnets_dhcp_cidr" {
  type        = list(any)
  description = "CIDR block for DHCP on Private Subnet"
}

variable "region" {
  description = "Region for the VPC"
}

variable "instance_type" {
  description = "Specifies the AWS instance type."
}

variable "ssh_public_key" {
  description = "SSH Public Key"
}

variable "cloud_provider" {
  description = "Cloud Provider (aws/azure)"
}
variable "hvn_cidr" {
  description = "HVN CIDR Range"
}

variable "home_cidr" {
  description = "Home Network CIDR Range"
}

variable "hcp_vault_tier" {
  description = "HCP Vault Tier"
}

variable "wg_server_private_key" {
  description = "Wireguard Server Private Key"
}

variable "wg_client_public_key" {
  description = "Wireguard Server Private Key"
}

variable "wg_client_ip" {
  description = "Wireguard Client IP"
}

variable "route53_hosted_zone_id" {
  description = "Route53 Hosted Zone ID"
}

variable "route53_domain_name" {
  description = "Route53 Domain (ex: hashicorp.com)"
}

variable "wg_server_net" {
  description = "Wireguard Server CIDR (.1 with the netmask)"
}

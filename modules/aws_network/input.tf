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
variable "public_subnets_dhcp_cidr" {
  type        = list(any)
  description = "CIDR block for DHCP on Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
}

variable "private_subnets_dhcp_cidr" {
  type        = list(any)
  description = "CIDR block for DHCP on Private Subnet"
}
variable "availability_zones" {
  type        = list(any)
  description = "List of Availablity Zones"
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

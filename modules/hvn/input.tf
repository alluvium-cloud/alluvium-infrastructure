variable "environment" {
  description = "This environment will be included in the name of most resources."
}

variable "cloud_provider" {
  description = "Cloud Provider (aws/azure)"
}

variable "region" {
  description = "Region for the VPC"
}
#
# variable "vpc_id" {
#   description = "VPC ID"
# }
#
# variable "owner_id" {
#   description = "AWS Owner (Account) ID"
# }

# variable "vpc_cidr" {
#   description = "CIDR block of the vpc"
# }

variable "hvn_cidr" {
  description = "HVN CIDR Range"
}

# variable "home_cidr" {
#   description = "Home Network CIDR Range"
# }
#
# variable "public_rtb_id" {
#   description = "Public Route Table ID"
# }
#
# variable "private_rtb_id" {
#   description = "Private Route Table ID"
# }
#
# variable "default_rtb_id" {
#   description = "Default Route Table ID"
# }

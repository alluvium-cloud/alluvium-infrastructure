# variable "environment" {
#   description = "This environment will be included in the name of most resources."
# }

# variable "vpc_cidr" {
#   description = "CIDR block of the vpc"
# }
#
# variable "public_subnets_cidr" {
#   type        = list(any)
#   description = "CIDR block for Public Subnet"
# }
# variable "public_subnets_dhcp_cidr" {
#   type        = list(any)
#   description = "CIDR block for DHCP on Public Subnet"
# }
#
# variable "private_subnets_cidr" {
#   type        = list(any)
#   description = "CIDR block for Private Subnet"
# }
#
# variable "private_subnets_dhcp_cidr" {
#   type        = list(any)
#   description = "CIDR block for DHCP on Private Subnet"
# }
# variable "availability_zones" {
#   type        = list(any)
#   description = "List of Availablity Zones"
# }
#
variable "region" {
  description = "Region for the VPC"
}
#
# variable "ssh_public_key" {
#   description = "SSH Public Key"
# }
#
# variable "use_route53" {
#   type        = bool
#   default     = false
#   description = "Whether to use SSM to store Wireguard Server private key."
# }

variable "route53_hosted_zone_id" {
  type        = string
  default     = null
  description = "Route53 Hosted zone ID."
}

variable "route53_domain_name" {
  type        = string
  default     = null
  description = "Route53 Domain (ex: hashicorp.com)"
}


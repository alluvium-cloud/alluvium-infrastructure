variable "environment" {
  description = "This environment will be included in the name of most resources."
}

variable "region" {
  description = "Region for the VPC"
}
variable "use_route53" {
  type        = bool
  default     = false
  description = "Whether to use SSM to store Wireguard Server private key."
}

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
variable "ssh_public_key" {
  description = "SSH Public Key"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_id" {
  description = "Subnet ID for Bastion Host"
}


variable "instance_type" {
  description = "Instance Type for Bastion Host"
}

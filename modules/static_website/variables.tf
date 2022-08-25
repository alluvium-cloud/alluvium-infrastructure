variable "route53_hosted_zone_id" {
  type        = string
  default     = null
  description = "Route53 Hosted zone ID."
}

variable "static_website_name" {
  type        = string
  default     = null
  description = "Static Website Name (For S3 and Route53) (ex: blah.alluvium.cloud)"
}

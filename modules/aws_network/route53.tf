resource "aws_route53_record" "cube" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "cube.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = ["192.168.1.4"]
}

resource "aws_route53_record" "hypercube" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "hypercube.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = ["192.168.1.5"]
}

resource "aws_route53_record" "horizon" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "horizon.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = ["192.168.1.6"]
}
resource "aws_route53_record" "dev" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "dev.${var.route53_domain_name}"
  type            = "A"
  ttl             = "60"
  records         = ["35.86.201.37"]
}

resource "aws_route53_record" "alluvium-cloud" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "${var.route53_domain_name}"
  type            = "CNAME"
  ttl             = "86400"
  records         = ["cname.vercel-dns.com."]
}

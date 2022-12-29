resource "aws_route53_record" "cube" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "cube.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["192.168.1.4"]
}

resource "aws_route53_record" "localhost" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "localhost.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["127.0.0.1"]
}

resource "aws_route53_record" "hypercube" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "hypercube.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["192.168.1.5"]
}

resource "aws_route53_record" "horizon" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "horizon.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["192.168.1.6"]
}

resource "aws_route53_record" "printer-a" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "EPSONA9C4C6.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["192.168.1.50"]
}

resource "aws_route53_record" "printer-cname" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "printer.${var.route53_domain_name}"
  type            = "CNAME"
  ttl             = "86400"
  records         = ["EPSONA9C4C6.alluvium.cloud."]
}

resource "aws_route53_record" "alluvium-cloud" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "${var.route53_domain_name}"
  type            = "A"
  ttl             = "3600"
  records         = ["76.76.21.21"]
}
resource "aws_route53_record" "www-alluvium-cloud" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "www.${var.route53_domain_name}"
  type            = "CNAME"
  ttl             = "3600"
  records         = ["cname.vercel-dns.com."]
}

resource "aws_route53_record" "dev-alluvium-cloud" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "dev.${var.route53_domain_name}"
  type            = "CNAME"
  ttl             = "3600"
  records         = ["cname.vercel-dns.com."]
}

# Hosted Zone for home.alluvium.cloud
resource "aws_route53_zone" "zone_home" {
  name    = "home.alluvium.cloud"
  comment = "Hosted Zone for home.alluvium.cloud"
}


resource "aws_route53_record" "ns_record_home" {
  type    = "NS"
  zone_id = var.route53_hosted_zone_id
  name    = "home"
  ttl     = "86400"
  records = aws_route53_zone.zone_home.name_servers
}


resource "aws_route53_record" "a_record_home" {
  type    = "A"
  zone_id = aws_route53_zone.zone_home.zone_id
  name    = "home.alluvium.cloud"
  ttl     = "300"
  records = ["172.245.225.23"]
}

resource "aws_route53_record" "wildcard_home" {
  zone_id = aws_route53_zone.zone_home.zone_id
  name    = "*.home.alluvium.cloud"
  type    = "A"
  ttl     = "86400"
  records = ["172.245.225.23"]
}


# alluvium.cloud records
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

resource "aws_route53_record" "pve1" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "pve1.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["192.168.1.7"]
}

resource "aws_route53_record" "nfs" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "nfs.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["192.168.1.250"]
}

resource "aws_route53_record" "minecraft" {
  allow_overwrite = true
  zone_id         = var.route53_hosted_zone_id
  name            = "minecraft.${var.route53_domain_name}"
  type            = "A"
  ttl             = "86400"
  records         = ["172.245.225.23"]
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
  name            = var.route53_domain_name
  type            = "A"
  ttl             = "3600"
  records         = ["172.245.225.23"]
}

# resource "aws_route53_record" "www-alluvium-cloud" {
#   allow_overwrite = true
#   zone_id         = var.route53_hosted_zone_id
#   name            = "www.${var.route53_domain_name}"
#   type            = "CNAME"
#   ttl             = "3600"
#   records         = ["cname.vercel-dns.com."]
# }

# resource "aws_route53_record" "dev-alluvium-cloud" {
#   allow_overwrite = true
#   zone_id         = var.route53_hosted_zone_id
#   name            = "dev.${var.route53_domain_name}"
#   type            = "CNAME"
#   ttl             = "3600"
#   records         = ["cname.vercel-dns.com."]
# }

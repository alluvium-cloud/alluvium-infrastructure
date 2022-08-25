resource "aws_s3_bucket" "website_bucket" {
  bucket = var.static_website_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.static_website_name}/*"
    ]
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.route53_hosted_zone_id
  name    = var.static_website_name
  type    = "A"
  alias {
    name                   = aws_s3_bucket.website_bucket.website_domain
    zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_zone" "test_zone" {
  name = "example.com"
}

resource "aws_route53_record" "test_record" {
  zone_id = aws_route53_zone.test_zone.id
  name    = "example.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.test_cf.domain_name
    zone_id                = aws_cloudfront_distribution.test_cf.hosted_zone_id
    evaluate_target_health = false
  }
}
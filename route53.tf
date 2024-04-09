#--------------------------------------------------------
# Route53
#--------------------------------------------------------

# route53 for clixx application
resource "aws_route53_record" "clixx_route53" {
  zone_id = data.aws_route53_zone.stack_isaac_zone.id
  name    = "dev.clixx"
  type    = "A"
  # ttl     = 5

  alias {
    name                   = aws_lb.clixx_lb.dns_name
    zone_id                = aws_lb.clixx_lb.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_lb.clixx_lb]
}

# route53 for blog
resource "aws_route53_record" "blog_route53" {
  zone_id = data.aws_route53_zone.stack_isaac_zone.id
  name    = "dev.blog"
  type    = "A"
  # ttl     = 5

  alias {
    name                   = aws_lb.blog_lb.dns_name
    zone_id                = aws_lb.blog_lb.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_lb.blog_lb]
}

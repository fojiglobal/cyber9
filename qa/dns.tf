# resource "aws_route53_record" "qa" {
#   zone_id = data.aws_route53_zone.fojiapps.zone_id
#   name    = "www.${data.aws_route53_zone.fojiapps.name}"
#   type    = "A"
#   ttl     = "300"
#   records = ["10.0.0.1"]
# }

resource "aws_route53_record" "qa" {
  zone_id = data.aws_route53_zone.fojiapps.zone_id
  name    = "qa.fojiapps.com"
  type    = "A"

  alias {
    name                   = aws_lb.qa_alb.dns_name
    zone_id                = aws_lb.qa_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_qa" {
  zone_id = data.aws_route53_zone.fojiapps.zone_id
  name    = "www.qa.fojiapps.com"
  type    = "A"

  alias {
    name                   = aws_lb.qa_alb.dns_name
    zone_id                = aws_lb.qa_alb.zone_id
    evaluate_target_health = false
  }
}
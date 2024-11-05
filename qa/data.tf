data "aws_route53_zone" "fojiapps" {
  name = "fojiapps.com."
}

######### Web Base AMI ###############

data "aws_ami" "example" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["test-web-*"]
  }
}

data "aws_acm_certificate" "alb_cert" {
  domain      = "www.stage.fojiapps.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
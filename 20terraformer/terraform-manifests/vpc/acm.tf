# ACM Module - To create and Verify SSL Certificates
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.1.0"

  domain_name = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  zone_id     = data.aws_route53_zone.mydomain.zone_id

  subject_alternative_names = [
    "*.smat710.tk"
  ]
  tags = local.common_tags
}



# RAAS-425
resource "aws_route53_record" "holmes-user-search-personalize-alias" {
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-user-search-personalize--redis.prod"
  type    = "CNAME"
  ttl     = 60
  records = ["holmes-user-search-personalize-prod-rep.ike8ni.ng.0001.usw1.cache.amazonaws.com"]
}

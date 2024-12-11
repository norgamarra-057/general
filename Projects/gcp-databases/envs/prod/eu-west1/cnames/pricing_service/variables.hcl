dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "pricing_service"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-emea-pricing-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pricing-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-emea-pricing-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pricing-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

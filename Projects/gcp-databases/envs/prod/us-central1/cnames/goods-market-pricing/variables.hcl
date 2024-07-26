dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "goods-market-pricing"
cnames = [
{
db_access_type = "rw"
aws_backend = "goods-market-pricing-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-053-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "goods-market-pricing-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-053-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

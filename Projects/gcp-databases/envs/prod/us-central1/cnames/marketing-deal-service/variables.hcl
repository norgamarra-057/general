dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "marketing-deal-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "marketing-deal-service-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-us-200-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "marketing-deal-service-prod-1.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-us-200-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

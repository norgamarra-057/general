dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "partner-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-noncore-us-053-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-053-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "pg-noncore-us-053-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-053-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

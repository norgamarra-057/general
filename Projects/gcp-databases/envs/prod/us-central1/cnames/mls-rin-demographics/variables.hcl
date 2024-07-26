dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "mls-rin-demographics"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-noncore-gl-461-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-gl-461-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "pg-noncore-gl-461-prod-1.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-gl-461-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "mbus-sigint-config"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-noncore-us-051-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-051-stg-rw.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "pg-noncore-us-051-prod-1.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-051-stg-ro.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "mbus-validation"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-au-noncore-us-701-prod.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-061-stg-rw.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "pg-au-noncore-us-701-prod.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-061-stg-ro.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

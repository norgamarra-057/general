dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "ugc-api-jtier"
cnames = [
{
db_access_type = "rw"
aws_backend = "ugc-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-us-153-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-ugc-prod-ro.prod.us-west-1.aws.groupondev.com."
gcp_backend = "pg-core-us-153-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

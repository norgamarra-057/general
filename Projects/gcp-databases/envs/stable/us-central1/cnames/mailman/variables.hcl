dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "mailman"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-noncore-us-516-stg.ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-007-stg-rw.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "pg-noncore-us-516-stg-1.ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-007-stg-ro.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

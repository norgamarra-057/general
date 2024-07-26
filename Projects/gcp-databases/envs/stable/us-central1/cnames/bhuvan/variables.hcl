dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "bhuvan"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-core-emea-581-stg.csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "pg-core-us-104-stg-rw.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "pg-core-emea-581-stg-1.csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "pg-core-us-104-stg-ro.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

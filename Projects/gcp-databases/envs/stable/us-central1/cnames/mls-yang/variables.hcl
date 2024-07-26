dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "mls-yang"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-au-noncore-us-701-stg.cluster-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-004-stg-rw.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "pg-au-noncore-us-701-stg.cluster-ro-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-004-stg-ro.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

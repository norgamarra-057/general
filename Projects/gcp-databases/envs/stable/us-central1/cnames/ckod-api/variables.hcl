dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "ckod-api"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-noncore-us-503-stg.cluster-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "my-noncore-us-503-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "my-noncore-us-503-stg.cluster-ro-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "my-noncore-us-503-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

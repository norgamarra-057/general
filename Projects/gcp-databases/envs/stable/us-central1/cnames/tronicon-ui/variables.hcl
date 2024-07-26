dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "tronicon-ui"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-core-us-521-stg.cluster-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "my-core-us-521-stg-2.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "my-core-us-521-stg.cluster-ro-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
gcp_backend = "my-core-us-521-stg-2.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

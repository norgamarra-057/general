dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "killbill-payments"
cnames = [
{
db_access_type = "rw"
#aws_backend = "my-core-us-522-stg.cluster-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
aws_backend = "my-core-na-57-stg-v2.cluster-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
#gcp_backend = "my-core-us-522-stg-0.gds.stable.gcp.groupondev.com."
gcp_backend = "my-core-na-57-stg-v2-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
#aws_backend = "my-core-us-522-stg.cluster-ro-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
aws_backend = "my-core-na-57-stg-v2.cluster-ro-ccoxqscq6x7v.us-west-1.rds.amazonaws.com."
#gcp_backend = "my-core-us-522-stg-0.gds.stable.gcp.groupondev.com."
gcp_backend = "my-core-na-57-stg-v2-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

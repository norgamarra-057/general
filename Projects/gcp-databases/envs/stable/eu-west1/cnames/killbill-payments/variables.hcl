dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "killbill-payments"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-core-emea-57-stg.cluster-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "my-core-emea-572-killbill-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "my-core-emea-57-stg.cluster-ro-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "my-core-emea-572-killbill-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

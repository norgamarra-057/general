dns_managed_zone = "dz-stable-sharedvpc01-europe-west1-gds-stable"
db_cname = "my-noncore-gl-emea-601-stg"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-noncore-emea-601-stg.cluster-ro-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "my-noncore-gl-emea-601-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "my-noncore-emea-601-stg.cluster-ro-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "my-noncore-gl-emea-601-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

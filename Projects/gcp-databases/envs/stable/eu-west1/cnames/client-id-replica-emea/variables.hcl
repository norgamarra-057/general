dns_managed_zone = "dz-stable-sharedvpc01-europe-west1-gds-stable"
db_cname = "client-id-replica-emea"
cnames = [
{
db_access_type = "rw"
aws_backend = "client-id-stg-replica.cluster-ro-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "client-id-replica-emea-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "client-id-stg-replica.cluster-ro-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "client-id-replica-emea-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

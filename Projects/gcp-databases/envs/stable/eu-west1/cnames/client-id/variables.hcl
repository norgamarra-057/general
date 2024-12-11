dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "client-id"
cnames = [
{
db_access_type = "rw"
aws_backend = "client-id-stg-0.gds.stable.gcp.groupondev.com."
gcp_backend = "client-id-replica-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "client-id-stg-0.gds.stable.gcp.groupondev.com."
gcp_backend = "client-id-replica-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

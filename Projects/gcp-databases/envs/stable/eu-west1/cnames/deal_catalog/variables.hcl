dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "deal-catalog"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-core-gl-us-621-stg-2.gds.stable.gcp.groupondev.com."
gcp_backend = "my-core-gl-us-621-replica-stg-1.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "my-core-gl-us-621-stg-2.gds.stable.gcp.groupondev.com."
gcp_backend = "my-core-gl-us-621-replica-stg-1.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

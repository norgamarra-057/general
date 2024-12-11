dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "travel-search"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-noncore-us-501-stg-1.gds.stable.gcp.groupondev.com."
gcp_backend = "my-noncore-us-501-stg-1.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "my-noncore-us-501-stg-1.gds.stable.gcp.groupondev.com."
gcp_backend = "my-noncore-us-501-stg-1.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

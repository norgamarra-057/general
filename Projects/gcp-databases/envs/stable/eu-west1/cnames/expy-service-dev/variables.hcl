dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "expy-service-dev"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-noncore-gl-us-601-stg-0.gds.stable.gcp.groupondev.com."
gcp_backend = "my-noncore-gl-emea-601-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "my-noncore-gl-us-601-stg-0.gds.stable.gcp.groupondev.com."
gcp_backend = "my-noncore-gl-emea-601-stg-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

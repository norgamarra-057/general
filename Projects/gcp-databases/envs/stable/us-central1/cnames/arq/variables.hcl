dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "arq"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-core-us-101-stg-rw.gds.stable.gcp.groupondev.com."
gcp_backend = "pg-core-us-101-stg-rw.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "pg-core-us-101-stg-ro.gds.stable.gcp.groupondev.com."
gcp_backend = "pg-core-us-101-stg-ro.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

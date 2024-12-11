dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "lpapi"
cnames = [
{
db_access_type = "rw"
aws_backend = "lpapi-rw-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "lpapi-rw-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "lpapi-ro-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "lpapi-ro-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

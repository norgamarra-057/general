dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "sem-gcp-pipelines"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-noncore-us-057-prod-rw.gds.prod.gcp.groupondev.com."
gcp_backend = "pg-noncore-us-057-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "pg-noncore-us-057-prod-ro.gds.prod.gcp.groupondev.com."
gcp_backend = "pg-noncore-us-057-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

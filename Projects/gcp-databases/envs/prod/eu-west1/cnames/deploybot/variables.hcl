dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "deploybot"
cnames = [
{
db_access_type = "rw"
aws_backend = "deploybot-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "my-noncore-us-006-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "deploybot-ro-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "my-noncore-us-006-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

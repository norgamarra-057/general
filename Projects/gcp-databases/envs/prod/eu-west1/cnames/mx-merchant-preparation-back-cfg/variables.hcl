dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "mx-merchant-preparation-back-cfg"
cnames = [
{
db_access_type = "rw"
aws_backend = "mx-merchant-preparation-back-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "mx-merchant-preparation-back-rw-na-production-db.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "mx-merchant-preparation-back-ro-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "mx-merchant-preparation-back-ro-na-production-db.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

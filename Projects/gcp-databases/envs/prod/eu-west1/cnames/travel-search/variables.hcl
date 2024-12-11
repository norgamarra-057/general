dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "travel-search"
cnames = [
{
db_access_type = "rw"
aws_backend = "travel-search-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "travel-search-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "travel-search-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "travel-search-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

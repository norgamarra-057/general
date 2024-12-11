dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "seo-deal-api"
cnames = [
{
db_access_type = "rw"
aws_backend = "seo-deal-api-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "seo-deal-api-rw-na-production-db.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "seo-deal-api-ro-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "seo-deal-api-ro-na-production-db.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

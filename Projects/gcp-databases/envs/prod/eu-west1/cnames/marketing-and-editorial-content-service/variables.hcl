dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "marketing-and-editorial-content-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "marketing-and-editorial-content-service-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "marketing-and-editorial-content-service-rw-na-production-db.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "editorial-content-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-gl-982-prod-ro-emea.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

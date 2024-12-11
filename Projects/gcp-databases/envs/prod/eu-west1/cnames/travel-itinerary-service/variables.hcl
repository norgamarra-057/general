dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "travel-itinerary-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "travel-itinerary-service-rw-na-production-db.gds.prod.gcp.groupondev.co."
gcp_backend = "travel-itinerary-service-rw-na-production-db.gds.prod.gcp.groupondev.co."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "tis-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-gl-983-prod-ro-emea.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

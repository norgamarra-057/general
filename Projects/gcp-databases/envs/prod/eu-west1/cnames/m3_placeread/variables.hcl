dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "m3_placeread"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-m3-place-service-prod-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-core-gl-982-prod-ro-emea.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-m3-place-service-prod-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-core-gl-982-prod-ro-emea.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

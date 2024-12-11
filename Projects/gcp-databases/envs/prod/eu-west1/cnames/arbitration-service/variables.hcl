dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "arbitration-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "arbitration-service-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-arbitration-service-emea-prod-rw.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-arbitration-service-prod-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-arbitration-service-emea-prod-ro.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

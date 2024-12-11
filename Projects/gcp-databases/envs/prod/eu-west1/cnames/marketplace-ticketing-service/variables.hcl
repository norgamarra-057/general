dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "marketplace-ticketing-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-noncore-emea-252-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-emea-252-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "pg-noncore-emea-252-prod-1.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-noncore-emea-252-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

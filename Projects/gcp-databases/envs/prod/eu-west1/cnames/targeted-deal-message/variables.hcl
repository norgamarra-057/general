dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "targeted-deal-message"
cnames = [
{
db_access_type = "rw"
aws_backend = "user-behavior-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-emea-352-prod-rw.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "user-behavior-prod-1.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-emea-352-prod-ro.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

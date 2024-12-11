dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "mls-sentinel-deal-index"
cnames = [
{
db_access_type = "rw"
aws_backend = "mls-deal-index-prod-replica.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-mls-deal-index-emea-prod-ro.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "mls-deal-index-prod-replica.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-mls-deal-index-emea-prod-ro.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

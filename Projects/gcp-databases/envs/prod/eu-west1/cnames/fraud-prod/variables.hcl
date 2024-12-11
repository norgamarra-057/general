dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "fraud-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "fraud-prod.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "fraud-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "fraud-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "fraud-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

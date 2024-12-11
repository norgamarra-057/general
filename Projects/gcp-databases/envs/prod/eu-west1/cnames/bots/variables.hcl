dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "bots"
cnames = [
{
db_access_type = "rw"
aws_backend = "booking-tool-prod.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "booking-tool-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "booking-tool-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "booking-tool-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

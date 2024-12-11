dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "tronicon_service"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-core-emea-301-prod.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "my-core-emea-301-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "my-core-emea-301-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "my-core-emea-301-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

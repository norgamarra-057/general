dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "ams"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-noncore-emea-202-prod.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "my-noncore-emea-202-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "my-noncore-emea-202-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "my-noncore-emea-202-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

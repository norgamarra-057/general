dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "m3_merchant_service"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-noncore-gl-441-prod-emea.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "my-noncore-gl-441-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "my-noncore-gl-441-prod-emea.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "my-noncore-gl-441-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

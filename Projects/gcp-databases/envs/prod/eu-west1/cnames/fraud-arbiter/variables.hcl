dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "fraud-arbiter"
cnames = [
{
db_access_type = "rw"
aws_backend = "fraud-arbiter-emea-prod-cluster.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "fraud-arbiter-emea-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "fraud-arbiter-emea-prod-cluster.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "fraud-arbiter-emea-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

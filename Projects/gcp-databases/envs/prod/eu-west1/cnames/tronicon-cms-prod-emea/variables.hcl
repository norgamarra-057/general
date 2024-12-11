db_cname = "tronicon-cms-prod-emea"
cnames = [
{
db_access_type = "rw"
aws_backend = "tronicon-cms-prod-replica.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "tronicon-cms-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "tronicon-cms-prod-replica.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "tronicon-cms-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

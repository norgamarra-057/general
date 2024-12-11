db_cname = "getaways-content-prod-emea"
cnames = [
{
db_access_type = "rw"
aws_backend = "getaways-content-prod-replica.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "getaways-content-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "getaways-content-prod-replica.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "getaways-content-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

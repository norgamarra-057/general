db_cname = "dealservice-prod-emea"
cnames = [
{
db_access_type = "rw"
aws_backend = "dealservice-prod-replica-new.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "dealservice-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "dealservice-prod-replica-new.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "dealservice-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

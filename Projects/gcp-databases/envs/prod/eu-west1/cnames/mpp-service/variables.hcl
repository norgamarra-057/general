db_cname = "mpp-service-replica"
cnames = [
{
db_access_type = "rw"
aws_backend = "mpp-service-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-gl-982-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "mpp-service-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-gl-982-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]
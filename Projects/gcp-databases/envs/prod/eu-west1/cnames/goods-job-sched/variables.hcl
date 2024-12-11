dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "goods-job-sched"
cnames = [
{
db_access_type = "rw"
aws_backend = "goods-job-sched-prod.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "goods-job-sched-emea-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "goods-job-sched-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "goods-job-sched-emea-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

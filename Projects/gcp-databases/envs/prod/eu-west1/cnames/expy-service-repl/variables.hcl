dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "expy-service-repl"
cnames = [
{
db_access_type = "rw"
aws_backend = "expy-service-replemea.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "expy-service-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "expy-service-replemea.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "expy-service-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

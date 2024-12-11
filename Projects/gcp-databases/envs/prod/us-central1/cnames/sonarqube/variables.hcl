dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "sonarqube"
cnames = [
{
db_access_type = "rw"
aws_backend = "sonarqube-prod.cjkehezkc6xn.us-west-2.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-061-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "sonarqube-prod.cjkehezkc6xn.us-west-2.rds.amazonaws.com."
gcp_backend = "pg-noncore-us-061-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

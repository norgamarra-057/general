dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "users-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-users-prod-rw.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "users-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-users-prod-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "users-prod-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

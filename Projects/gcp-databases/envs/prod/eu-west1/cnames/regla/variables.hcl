dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "regla"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-regla-prod-rw.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-core-emea-354-prod-rw.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-regla-prod-rw.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-core-emea-354-prod-ro.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "bhuvan"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-emea-bhuvan-prod-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-core-us-154-prod-emea-replica-ro.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-emea-bhuvan-prod-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-core-us-154-prod-emea-replica-ro.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

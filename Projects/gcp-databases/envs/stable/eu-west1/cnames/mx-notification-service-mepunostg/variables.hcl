dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "mx-notification-service-mepunostg"
cnames = [
{
db_access_type = "rw"
aws_backend = "pg-noncore-emea-561-stg.csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "pg-noncore-emea-561-stg-rw.europe-west1.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "pg-noncore-emea-561-stg-1.csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "pg-noncore-emea-561-stg-ro.europe-west1.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

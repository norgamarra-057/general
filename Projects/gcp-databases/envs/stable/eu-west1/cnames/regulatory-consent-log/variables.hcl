dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "regulatory-consent-log"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-pg-noncore-emea-561-stg-rw.stable.us-west-2.aws.groupondev.com."
gcp_backend = "pg-noncore-emea-561-stg-rw.europe-west1.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-pg-noncore-emea-561-stg-ro.stable.us-west-2.aws.groupondev.com."
gcp_backend = "pg-noncore-emea-561-stg-ro.europe-west1.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

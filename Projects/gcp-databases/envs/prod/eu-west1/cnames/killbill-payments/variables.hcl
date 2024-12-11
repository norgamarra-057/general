dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "killbill-payments"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-killbill-payments-prod-rw.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "killbill-payments-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-killbill-payments-prod-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "killbill-payments-emea-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

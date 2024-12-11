dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "voucher-inventory-jtier"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-emea-vis20-rw.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "vis20-emea-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-emea-vis20-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "vis20-emea-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

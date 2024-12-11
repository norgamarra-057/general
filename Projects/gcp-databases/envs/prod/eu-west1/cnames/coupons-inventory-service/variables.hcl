dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "coupons-inventory-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "coupons-inventory-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-gl-983-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "coupons-inventory-emea-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "pg-core-gl-983-prod-ro-emea.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

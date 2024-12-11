dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "coupons-revproc"
cnames = [
{
db_access_type = "rw"
aws_backend = "coupons-revproc-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "coupons-prod-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "coupons-revproc-ro-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "coupons-prod-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

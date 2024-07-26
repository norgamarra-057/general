dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "livingsocial-voucher-archive-orders"
cnames = [
{
db_access_type = "rw"
aws_backend = "ls-va-orders-prod.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "ls-va-orders-prod-1.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "ls-va-orders-prod.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "ls-va-orders-prod-1.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

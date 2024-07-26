dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "rise"
cnames = [
{
db_access_type = "rw"
aws_backend = "rise-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "rise-prod.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "rise-prod-1.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "rise-prod.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "backbeat"
cnames = [
{
db_access_type = "rw"
aws_backend = "backbeat-acct-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-us-157-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "backbeat-acct-prod.czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-us-157-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

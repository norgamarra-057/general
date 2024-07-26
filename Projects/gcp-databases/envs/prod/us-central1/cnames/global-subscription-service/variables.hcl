dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "global-subscription-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "global-subscription-service-prod.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-subscription-service-us-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "global-subscription-service-prod.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-subscription-service-us-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

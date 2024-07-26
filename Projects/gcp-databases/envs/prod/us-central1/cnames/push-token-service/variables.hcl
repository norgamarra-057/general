dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "push-token-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "mobile-push-token-service-prod.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-mobile-push-token-us-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "mobile-push-token-service-prod.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "pg-mobile-push-token-us-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

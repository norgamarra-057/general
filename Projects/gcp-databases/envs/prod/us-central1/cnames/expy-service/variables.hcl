dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "expy-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "expy-service.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "expy-service-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "expy-service.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "expy-service-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]
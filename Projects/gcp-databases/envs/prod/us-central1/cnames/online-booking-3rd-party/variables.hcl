dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "online-booking-3rd-party"
cnames = [
{
db_access_type = "rw"
aws_backend = "be-3rd-party-prod.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "be-3rd-party-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "be-3rd-party-prod.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "be-3rd-party-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

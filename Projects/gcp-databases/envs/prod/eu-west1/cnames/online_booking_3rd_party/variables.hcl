dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "online_booking_3rd_party"
cnames = [
{
db_access_type = "rw"
aws_backend = "booking-3rdparty-prod.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "booking-3rdparty-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "booking-3rdparty-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "booking-3rdparty-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "calendar-service-booking"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-ol-book-avail-prod-rw.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "ol-book-avail-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "ol-book-avail-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "ol-book-avail-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

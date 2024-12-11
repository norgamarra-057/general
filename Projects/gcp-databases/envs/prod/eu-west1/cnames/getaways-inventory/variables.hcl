dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "getaways-inventory"
cnames = [
{
db_access_type = "rw"
aws_backend = "getaways-inventory-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "gtwy-travel-inv-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-gtwy-travel-inv-prod-emea-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "gtwy-travel-inv-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

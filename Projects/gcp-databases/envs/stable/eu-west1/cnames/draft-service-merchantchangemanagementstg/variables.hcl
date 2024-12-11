dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "draft-service-merchantchangemanagementstg"
cnames = [
{
db_access_type = "rw"
aws_backend = "draft-service-merch-chg-mgmt-rw-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "draft-service-merch-chg-mgmt-rw-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "draft-service-merch-chg-mgmt-ro-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "draft-service-merch-chg-mgmt-ro-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "getaways-partner-integrator-partner-gwl"
cnames = [
{
db_access_type = "rw"
aws_backend = "getaways-partner-integrator-gwl-rw-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "my-core-us-102-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "getaways-partner-integrator-gwl-ro-na-production-db.gds.prod.gcp.groupondev.com."
gcp_backend = "my-core-us-102-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

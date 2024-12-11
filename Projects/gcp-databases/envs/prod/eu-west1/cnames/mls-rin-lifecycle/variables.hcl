dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "mls-rin-lifecycle"
cnames = [
{
db_access_type = "rw"
aws_backend = "merch-lifecycle-prod-replica2.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-gl-983-prod-ro-emea.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "merch-lifecycle-prod-replica2.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-gl-983-prod-ro-emea.europe-west1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "prodcutover-57version"
cnames = [
{
db_access_type = "rw"
aws_backend = "prodcutover-test-cluster.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "prodcutover-57version-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "prodcutover-test-cluster.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "prodcutover-57version-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

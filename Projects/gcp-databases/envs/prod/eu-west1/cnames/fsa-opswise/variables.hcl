dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "fsa-opswise"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-noncore-us-111-prod.cluster-cjkehezkc6xn.us-west-2.rds.amazonaws.com."
gcp_backend = "my-noncore-us-111-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "my-noncore-us-111-prod.cluster-ro-cjkehezkc6xn.us-west-2.rds.amazonaws.com."
gcp_backend = "my-noncore-us-111-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

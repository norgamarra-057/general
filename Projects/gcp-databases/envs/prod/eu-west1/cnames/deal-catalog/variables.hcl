dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "deal-catalog"
cnames = [
{
db_access_type = "rw"
aws_backend = "gds-dealservice-prod-replica-new-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "dealservice-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "gds-dealservice-prod-replica-new-ro.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "dealservice-prod-emea-1.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

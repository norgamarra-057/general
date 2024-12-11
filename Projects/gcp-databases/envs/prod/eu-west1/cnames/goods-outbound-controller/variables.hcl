dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "goods-outbound-controller"
cnames = [
{
db_access_type = "rw"
aws_backend = "goods-oc-prod.cluster-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "goods-oc-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "goods-oc-prod.cluster-ro-cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "goods-oc-prod-0.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "goods-shipment-service"
cnames = [
{
db_access_type = "rw"
aws_backend = "goods-shipment-stg.cluster-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "goods-shipment-stg-emea-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "goods-shipment-stg.cluster-ro-csgyhkohakjl.us-west-2.rds.amazonaws.com."
gcp_backend = "goods-shipment-stg-emea-0.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

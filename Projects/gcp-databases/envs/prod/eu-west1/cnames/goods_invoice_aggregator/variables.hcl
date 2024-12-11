dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "goods_invoice_aggregator"
cnames = [
{
db_access_type = "rw"
aws_backend = "goods-invoicing-prod.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-emea-354-prod-rw.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "goods-invoicing-prod-1.cqgqresxrenm.eu-west-1.rds.amazonaws.com."
gcp_backend = "pg-core-emea-354-prod-ro.gds.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

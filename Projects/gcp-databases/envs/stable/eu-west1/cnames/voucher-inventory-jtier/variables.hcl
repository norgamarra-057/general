dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "voucher-inventory-jtier"
cnames = [
{
db_access_type = "rw"
aws_backend = "my-core-na-57-stg-2.gds.stable.gcp.groupondev.com."
gcp_backend = "my-core-na-57-stg-replica-1.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "my-core-na-57-stg-2.gds.stable.gcp.groupondev.com."
gcp_backend = "my-core-na-57-stg-replica-1.gds.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

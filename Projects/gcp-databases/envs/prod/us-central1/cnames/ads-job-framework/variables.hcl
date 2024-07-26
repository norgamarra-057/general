dns_managed_zone = "dz-prod-sharedvpc01-gds-prod"
db_cname = "ads-job-framework"
cnames = [
{
db_access_type = "rw"
aws_backend = "ad-inv-serv-prod.cluster-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "ad-inv-serv-prod-1.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
},
{
db_access_type = "ro"
aws_backend = "ad-inv-serv-prod.cluster-ro-czlsgz0xic0p.us-west-1.rds.amazonaws.com."
gcp_backend = "ad-inv-serv-prod-1.gds.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]

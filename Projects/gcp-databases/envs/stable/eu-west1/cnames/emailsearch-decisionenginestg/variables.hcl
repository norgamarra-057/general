dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "emailsearch-decisionenginestg"
cnames = [
{
db_access_type = "rw"
aws_backend = "emailsearch-decision-engine-rw-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "emailsearch-decision-engine-rw-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "emailsearch-decision-engine-ro-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "emailsearch-decision-engine-ro-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

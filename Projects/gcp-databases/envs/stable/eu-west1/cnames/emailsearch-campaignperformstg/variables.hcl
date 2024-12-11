dns_managed_zone = "dz-stable-sharedvpc01-gds-stable"
db_cname = "emailsearch-campaignperformstg"
cnames = [
{
db_access_type = "rw"
aws_backend = "emailsearch-campaign-perform-rw-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "emailsearch-campaign-perform-rw-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
},
{
db_access_type = "ro"
aws_backend = "emailsearch-campaign-perform-ro-na-staging-db.gds.stable.gcp.groupondev.com."
gcp_backend = "emailsearch-campaign-perform-ro-na-staging-db.gds.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]

terraform {
source = run_cmd(
"${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
"redis-cname"
)
}

include {
path = find_in_parent_folders()
}

inputs = {
cache_cname = "inbox-mgmt-mobile-prod-users27-memorystore.us-central1.caches.prod.gcp.groupondev.com."
cnames = [
{
aws_backend = "inbox-mgmt-mobile-prod-users27--redis.prod.prod.us-west-1.aws.groupondev.com."
gcp_backend = "inbox-mgmt-mobile-prod-users27.us-central1.caches.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]
}

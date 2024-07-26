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
cache_cname = "cs-api-memorystore.us-central1.caches.prod.gcp.groupondev.com."
cnames = [
{
aws_backend = "cs-api--redis.prod.prod.us-west-1.aws.groupondev.com."
gcp_backend = "cs-api.us-central1.caches.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]
}

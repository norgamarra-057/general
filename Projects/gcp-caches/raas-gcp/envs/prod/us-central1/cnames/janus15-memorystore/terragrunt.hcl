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
cache_cname = "janus15-memorystore.us-central1.caches.prod.gcp.groupondev.com."
cnames = [
{
aws_backend = "janus15--redis.prod.prod.us-west-1.aws.groupondev.com."
gcp_backend = "janus15.us-central1.caches.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]
}

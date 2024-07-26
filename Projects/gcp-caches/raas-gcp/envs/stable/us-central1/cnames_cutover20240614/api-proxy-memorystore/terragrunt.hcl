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
cache_cname = "api-proxy-memorystore.us-central1.caches.stable.gcp.groupondev.com."
cnames = [
{
aws_backend = "api-proxy--redis.staging.stable.us-west-1.aws.groupondev.com."
gcp_backend = "api-proxy.us-central1.caches.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]
}

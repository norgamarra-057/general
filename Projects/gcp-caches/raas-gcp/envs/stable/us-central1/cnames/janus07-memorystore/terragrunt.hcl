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
cache_cname = "janus07-memorystore.us-central1.caches.stable.gcp.groupondev.com."
cnames = [
{
aws_backend = "janus07--redis.staging.stable.us-west-1.aws.groupondev.com."
gcp_backend = "janus07.us-central1.caches.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]
}

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
cache_cname = "badges-service-cloud-memorystore.us-central1.caches.stable.gcp.groupondev.com."
cnames = [
{
aws_backend = "badges-service-cloud--redis.staging.stable.us-west-1.aws.groupondev.com."
gcp_backend = "badges-service-cloud.us-central1.caches.stable.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]
}

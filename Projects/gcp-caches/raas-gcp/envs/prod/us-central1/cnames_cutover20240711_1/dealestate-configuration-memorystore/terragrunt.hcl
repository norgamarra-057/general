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
cache_cname = "dealestate-configuration-memorystore.us-central1.caches.prod.gcp.groupondev.com."
cnames = [
{
aws_backend = "dealestate-configuration--redis.prod.prod.us-west-1.aws.groupondev.com."
gcp_backend = "dealestate-configuration.us-central1.caches.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]
}

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
cache_cname = "goods-inventory-service-memorystore.us-central1.caches.stable.gcp.groupondev.com."
cnames = [
{
aws_backend = "goods-inventory-service--redis.staging.stable.us-west-1.aws.groupondev.com."
gcp_backend = "goods-inventory-service.us-central1.caches.stable.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]
}

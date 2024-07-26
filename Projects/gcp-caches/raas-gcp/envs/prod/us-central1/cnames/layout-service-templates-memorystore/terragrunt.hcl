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
cache_cname = "layout-service-templates-memorystore.us-central1.caches.prod.gcp.groupondev.com."
cnames = [
{
aws_backend = "layout-service-templates--redis.prod.prod.us-west-1.aws.groupondev.com."
gcp_backend = "layout-service-templates.us-central1.caches.prod.gcp.groupondev.com."
aws_weight = 0
gcp_weight = 1
}
]
}

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
cache_cname = "deckard-async-memorystore.europe-west1.caches.prod.gcp.groupondev.com."
cnames = [
{
aws_backend = "deckard-async--redis.prod.prod.eu-west-1.aws.groupondev.com."
gcp_backend = "deckard-async.europe-west1.caches.prod.gcp.groupondev.com."
aws_weight = 1
gcp_weight = 0
}
]
}

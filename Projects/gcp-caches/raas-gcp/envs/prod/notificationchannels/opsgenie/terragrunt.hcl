terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "notification-channel"
  )
}

include {
  path = find_in_parent_folders()
}

inputs = {
  channel_name = "RaaS Team Opsgenie"
  channel_type = "email"
  channel_address="raas@groupondev.opsgenie.net"
}
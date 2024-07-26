locals {
  valid_tiers = [
    "App",
    "DB",
    "Public",
  ]

  valid_availability_zones = [
    "a",
    "b",
    "c",
  ]

  valid_regions = [
    "eu-west-1",
    "us-east-1",
    "us-west-1",
    "us-west-2",
  ]

  valid_tenancies = [
    "default",
    "dedicated",
    "host",
  ]

  valid_cpu_credits = [
    "standard",
    "unlimited",
  ]

  valid_shutdown_behavior = [
    "",
    "stop",
    "terminate",
  ]

  default_tags = {
    "Owner" = var.owner
    "Usage" = var.usage
  }
}

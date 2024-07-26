terraform {
    source = "../../../../../modules/cloudwatch"
}

include {
  path = find_in_parent_folders()
}

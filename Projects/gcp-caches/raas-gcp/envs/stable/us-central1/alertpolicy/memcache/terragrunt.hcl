terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "memcache-alert-policy"
  )
}

include {
  path = find_in_parent_folders()
}

inputs = {
  #######################
  # Alerting thresholds #
  #######################
  # oom percent threshold
  #oom_warn_threshold_memcache = 0.8
  #oom_critical_threshold_memcache = 0.9
  oom_exclusion_list =[]

  # cpu percent threshold
  #cpu_warn_threshold_memcache = 0.8
  #cpu_critical_threshold_memcache = 0.9
  cpu_exclusion_list =[]

  # max connections based on 65k max value for redis
  #80%
  #max_connect_warn_threshold_memcache = 52000
  #%90
  #max_connect_critical_threshold_memcache = 58500
  max_cons_exclusion_list =[]

  labels = {
    service  = "raas"
    type = "memcache"
  }
}
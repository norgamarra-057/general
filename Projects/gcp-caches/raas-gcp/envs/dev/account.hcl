######################
# Project level Settings
######################
gcp_project_number = "458185886188"
gcp_project_id     = "prj-grp-caches-dev-50d1"

vpc_name = "vpc-dev-sharedvpc01"
vpc_project_id = "prj-grp-shared-vpc-dev-d89e"

env_short_name = "caches"
env_stage      = "dev"
environment = "dev"

#######################
# Alerting thresholds #
#######################
# oom percent threshold
oom_warn_threshold = 80
oom_critical_threshold = 90

# cpu percent threshold
cpu_warn_threshold = 80
cpu_critical_threshold = 90

# max connections based on 65k max value for redis
#80%
max_connect_warn_threshold = 52000
#%90
max_connect_critical_threshold = 58500

# In staging/production environments, you can pin the modules to a specific git tag:
#module_version = "v1.0.0"

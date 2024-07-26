######################
# Project level Settings
######################
gcp_project_number = "505167062465"
gcp_project_id     = "prj-grp-caches-prod-8a6d"

vpc_name = "vpc-prod-sharedvpc01"
vpc_project_id = "prj-grp-shared-vpc-prod-2511"

env_short_name = "caches"
env_stage      = "prod"

enviroment = "prod"

######################################
# Alerting thresholds redis instance #
######################################
# oom percent threshold
oom_warn_threshold_instance = 0.8
oom_critical_threshold_instance = 0.9

# cpu percent threshold
# metric is cpu time in sec per minute
#80%
cpu_warn_threshold_instance = 48
#90%
cpu_critical_threshold_instance = 54

# max connections based on 65k max value for redis
#80%
max_connect_warn_threshold_instance = 52000
#%90
max_connect_critical_threshold_instance = 58500

#####################################
# Alerting thresholds redis cluster #
#####################################
# oom percent threshold
oom_warn_threshold_cluster = 0.8
oom_critical_threshold_cluster = 0.9

# cpu percent threshold
cpu_warn_threshold_cluster = 0.8
cpu_critical_threshold_cluster = 0.9

# max connections based on 65k max value for redis
#80%
max_connect_warn_threshold_cluster = 52000
#%90
max_connect_critical_threshold_cluster = 58500

################################
# Alerting thresholds memcache #
################################
# oom percent threshold
oom_warn_threshold_memcache = 0.8
oom_critical_threshold_memcache = 0.9

# memcache cpu percent threshold
cpu_warn_threshold_memcache = 0.8
cpu_critical_threshold_memcache = 0.9

# max connections based on 65k max value for memcache
#80%
max_connect_warn_threshold_memcache = 52000
#%90
max_connect_critical_threshold_memcache = 58500

# In staging/production environments, you can pin the modules to a specific git tag:
#module_version = "v1.0.0"

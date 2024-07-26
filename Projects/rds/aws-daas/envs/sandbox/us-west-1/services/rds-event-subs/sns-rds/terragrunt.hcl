terraform {
	source = "../../../../../../modules/sns-rds"
}

include {
    path = find_in_parent_folders()
}

# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  account_id                               = get_aws_account_id()
  service_tag                              = "daas_postgres"
  owner_tag                                = "c_dmorales@groupon.com"
  tenantteam_tag                           = "gds@groupon.com"
  tenantservice_tag                        = "multi-tenant"
  jira_tag 		                   = "GDS-27301"

  sns_topic_name                           = "rds-db-events"
  sns_topic_fifo_topic                     = false

  sns_topic_subs_endpoint_email            = "dmorales@groupon.com" 
  sns_topic_subs_create_endpoint_email     = true

  sns_topic_subs_endpoint_sms              = "+000000000000"                  
  sns_topic_subs_create_endpoint_sms       = false

  db_event_subs_name   		           = "rds-dbinstance-events-sub"
  db_event_subs_event_enabled              = true

  delivery_policy_number_retries           = 5
  delivery_policy_number_max_delay_retries = 5
}


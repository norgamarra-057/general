resource "google_sql_database" "database" {
  name     = var.db_name
  project          = var.gcp_project_id
  instance = google_sql_database_instance.instance.name
}

data "google_compute_network" "private_network" {
  name    = var.db_vpc_name
  project = "prj-grp-shared-vpc-dev-d89e"
}



# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = var.db_instance_name
  region           = var.gcp_region
  project          = var.gcp_project_id
  database_version = var.db_version
  deletion_protection = false
  settings {
    tier = var.db_tier
    #memory             = var.memory
    #cpu                = var.cpu
    #storage_autoresize = true
    disk_size   = var.disk_size
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.google_compute_network.private_network.id
      enable_private_path_for_google_cloud_services = true

      psc_config {
        psc_enabled               = false
      #allowed_consumer_projects = [var.gcp_project_id]
      }
    #Add the database flags here
     database_flags = [
      {
        name  = "max_connections"
        value = var.max_connections
      },
      {
        name  = "max_allowed_packet"
        value = var.max_allowed_packet
      },
      {
        name  = "long_query_time"
        value = var.long_query_time
      },
      {
        name  = "log_output"
        value = var.log_output
      },
      { 
	      name  = "character_set_server"
        value = var.character_set_server
      },
      { 
	      name  = "character_set_client"
        value = var.character_set_client
      },
      { 
	      name  = "character_set_connection"
        value = var.character_set_connection
      },
      { 
	      name  = "character_set_results"
        value = var.character_set_results
      },
      { 
	      name  = "explicit_defaults_for_timestamp"
        value = var.explicit_defaults_for_timestamp
      },
      { 
	      name  = "log_bin_trust_function_creators"
        value = var.log_bin_trust_function_creators
      }
      
      ]

    }
    backup_configuration {
    enabled            = true
    binary_log_enabled = var.db_type == "mysql" ? true : null
    }

    #  replication_configuration {
    #  enabled = var.db_type == "mysql" ? var.replication_enabled : null
    #  kind    = var.db_type == "mysql" ? "MYSQL_REPLICATION" : null
    # }
  }
}
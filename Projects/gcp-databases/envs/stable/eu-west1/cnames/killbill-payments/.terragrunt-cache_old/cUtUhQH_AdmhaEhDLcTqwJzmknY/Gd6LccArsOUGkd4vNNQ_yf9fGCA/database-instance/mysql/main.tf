resource "google_sql_database" "database" {
  name     = var.db_name
  project  = var.gcp_project_id
  instance = google_sql_database_instance.instance.name
}

data "google_compute_network" "private_network" {
  name    = var.db_vpc_name
  project = var.vpc_name_project
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
    disk_size   = var.disk_size
    user_labels = {
      jira_tag          = var.jira_tag
      service_tag-code  = var.service_tag
      owner_tag         = var.owner_tag
      tenantteam_tag    = var.tenantteam_tag
      tenantservice_tag = var.tenantservice_tag
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.google_compute_network.private_network.id
      enable_private_path_for_google_cloud_services = true

      psc_config {
        psc_enabled               = false
      #allowed_consumer_projects = [var.gcp_project_id]
      }
    }
    
    #Add the dynamic database flags here

    dynamic "database_flags" {
      for_each = var.wait_timeout != null ? [1] : []
      content {
        name  = "wait_timeout"
        value = var.wait_timeout == null ? null : var.wait_timeout
      } 
    }
    dynamic "database_flags" {
      for_each = var.general_log != null ? [1] : []
      content {
        name  = "general_log"
        value = var.general_log == null ? null : var.general_log
      }
    }
    dynamic "database_flags" {
      for_each = var.max_connections != null ? [1] : []
      content {
        name  = "max_connections"
        value = var.max_connections == null ? null : var.max_connections
      }
    }
    dynamic "database_flags" {
      for_each = var.log_output != null ? [1] : []
      content {
        name  = "log_output"
        value = var.log_output == null ? null : var.log_output
      }
    }
    dynamic "database_flags" {
      for_each = var.long_query_time != null ? [1] : []
      content {
        name  = "long_query_time"
        value = var.long_query_time == null ? null : var.long_query_time
      }
    }
    #Add the backup configuration details here

    backup_configuration {
    enabled            = true
    binary_log_enabled = var.db_type == "mysql" ? true : null
    }
    
    #Add the common database flags here  
    
    database_flags {
      name  = "explicit_defaults_for_timestamp"
      value = 0
    }
    database_flags {
      name  = "log_bin_trust_function_creators"
      value = 1
    }
    database_flags {
      name  = "character_set_server"
      value = "utf8"
    }
  }
}
#[START cloud_sql_mysql_instance_user]
resource "google_sql_user" "admin_user" {
  name     = var.admin_username
  instance = google_sql_database_instance.instance.name
  project          = var.gcp_project_id
  password = var.admin_password
  host  = "%"
  }

#cloud_sql_mysql_instance_replica_configuration 
resource "google_sql_database_instance" "read_replica" {
  count            = var.replica_count > 0 ? var.replica_count : 0
  name             = "${var.db_instance_name}-replica-${count.index}"
 #name                 = var.db_replica_name
  master_instance_name = google_sql_database_instance.instance.name
  project          = var.gcp_project_id
  region               = var.gcp_region
  database_version     = var.db_version

  replica_configuration {
    failover_target = false
  }

    settings {
      tier = var.db_tier
      availability_type = "ZONAL"
      disk_size   = var.disk_size
      ip_configuration {
        ipv4_enabled                                  = false
        private_network                               = data.google_compute_network.private_network.id
        enable_private_path_for_google_cloud_services = true
      }
      user_labels = {
      jira_tag          = var.jira_tag
      service_tag-code  = var.service_tag
      owner_tag         = var.owner_tag
      tenantteam_tag    = var.tenantteam_tag
      tenantservice_tag = var.tenantservice_tag
      }

      #Add the dynamic database flags here
      dynamic "database_flags" {
        for_each = var.wait_timeout != null ? [1] : []
        content {
          name  = "wait_timeout"
          value = var.wait_timeout == null ? null : var.wait_timeout
          } 
      }
      dynamic "database_flags" {
        for_each = var.general_log != null ? [1] : []
        content {
          name  = "general_log"
          value = var.general_log == null ? null : var.general_log
        }
      }
      dynamic "database_flags" {
        for_each = var.max_connections != null ? [1] : []
        content {
          name  = "max_connections"
          value = var.max_connections == null ? null : var.max_connections
        }
      }
      dynamic "database_flags" {
        for_each = var.log_output != null ? [1] : []
        content {
          name  = "log_output"
          value = var.log_output == null ? null : var.log_output
        } 
      }
      dynamic "database_flags" {
        for_each = var.long_query_time != null ? [1] : []
        content {
          name  = "long_query_time"
          value = var.long_query_time == null ? null : var.long_query_time
       }
      }
      #Add the common database flags here

      database_flags {
        name  = "explicit_defaults_for_timestamp"
        value = 0
      }
      database_flags {
        name  = "log_bin_trust_function_creators"
        value = 1
        }
      database_flags {
        name  = "character_set_server"
        value = "utf8"
        }
    }
  }

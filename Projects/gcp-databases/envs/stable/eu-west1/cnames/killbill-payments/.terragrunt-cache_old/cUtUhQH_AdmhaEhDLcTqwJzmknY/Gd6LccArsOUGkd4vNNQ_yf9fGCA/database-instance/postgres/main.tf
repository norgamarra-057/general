resource "google_sql_database" "database" {
  name     = var.db_name
  project          = var.gcp_project_id
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
  master_instance_name = var.master_instance_name
#  deletion_protection = true
#  deletion_protection = false
  settings {
     deletion_protection_enabled = true
#     deletion_protection_enabled = false
     tier = var.db_tier
     disk_size   = var.disk_size
#    cpu                = var.cpu
#    storage_autoresize = true
#    storage_capacity   = var.storage

    database_flags {
      name  = "cloudsql.logical_decoding"
      value = var.cloudsql_logical_decoding ? "on" : "off"
    }


dynamic "database_flags" {
  for_each = var.autovacuum_vacuum_scale_factor != null ? [1] : []
  content {
    name  = "autovacuum_vacuum_scale_factor"
    value = var.autovacuum_vacuum_scale_factor == null ? null : var.autovacuum_vacuum_scale_factor
  }
}

dynamic "database_flags" {
  for_each = var.autovacuum_analyze_scale_factor != null ? [1] : []
  content {
    name  = "autovacuum_analyze_scale_factor"
    value = var.autovacuum_analyze_scale_factor == null ? null : var.autovacuum_analyze_scale_factor
  }
}


dynamic "database_flags" {
  for_each = var.autovacuum_max_workers != null ? [1] : []
  content {
    name  = "autovacuum_max_workers"
    value = var.autovacuum_max_workers == null ? null : var.autovacuum_max_workers
  }
}


dynamic "database_flags" {
  for_each = var.autovacuum_vacuum_cost_delay != null ? [1] : []
  content {
    name  = "autovacuum_vacuum_cost_delay"
    value = var.autovacuum_vacuum_cost_delay == null ? null : var.autovacuum_vacuum_cost_delay
  }
}


dynamic "database_flags" {
  for_each = var.checkpoint_timeout != null ? [1] : []
  content {
    name  = "checkpoint_timeout"
    value = var.checkpoint_timeout == null ? null : var.checkpoint_timeout
      }
    }

dynamic "database_flags" {
  for_each = var.default_statistics_target != null ? [1] : []
  content {
    name  = "default_statistics_target"
    value = var.default_statistics_target == null ? null : var.default_statistics_target
  }
}

dynamic "database_flags" {
  for_each = var.effective_cache_size != null ? [1] : []
  content {
    name = "effective_cache_size"
    value = var.effective_cache_size == null ? null : var.effective_cache_size
  }
}

dynamic "database_flags" {
  for_each = var.hot_standby_feedback != null ? [1] : []
  content {
    name  = "hot_standby_feedback"
    value = var.hot_standby_feedback == null ? null : var.hot_standby_feedback
  }
}

dynamic "database_flags" {
  for_each = var.log_autovacuum_min_duration != null ? [1] : []
  content {
    name  = "log_autovacuum_min_duration"
    value = var.log_autovacuum_min_duration == null ? null : var.log_autovacuum_min_duration
  }
}

dynamic "database_flags" {
  for_each = var.log_checkpoints != null ? [1] : []
  content {
    name  = "log_checkpoints"
    value = var.log_checkpoints == null ? null : var.log_checkpoints
  }
}

dynamic "database_flags" {
  for_each = var.log_connections != null ? [1] : []
  content {
    name  = "log_connections"
    value = var.log_connections == null ? null : var.log_connections
  }
}

dynamic "database_flags" {
  for_each = var.log_line_prefix != null ? [1] : []
  content {
    name  = "log_line_prefix"
    value = var.log_line_prefix == null ? null : var.log_line_prefix
  }
}

dynamic "database_flags" {
  for_each = var.log_lock_waits != null ? [1] : []
  content {
    name  = "log_lock_waits"
    value = var.log_lock_waits == null ? null : var.log_lock_waits
  }
}

dynamic "database_flags" {
  for_each = var.log_min_duration_statement != null ? [1] : []
  content {
    name  = "log_min_duration_statement"
    value = var.log_min_duration_statement == null ? null : var.log_min_duration_statement
  }
}

dynamic "database_flags" {
  for_each = var.log_statement != null ? [1] : []
  content {
    name  = "log_statement"
    value = var.log_statement == null ? null : var.log_statement
  }
}

dynamic "database_flags" {
  for_each = var.log_temp_files != null ? [1] : []
  content {
    name  = "log_temp_files"
    value = var.log_temp_files == null ? null : var.log_temp_files
  }
}

dynamic "database_flags" {
  for_each = var.maintenance_work_mem != null ? [1] : []
  content {
    name  = "maintenance_work_mem"
    value = var.maintenance_work_mem == null ? null : var.maintenance_work_mem
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
  for_each = var.max_logical_replication_workers  != null ? [1] : []
  content {
    name  = "max_logical_replication_workers"
    value = var.max_logical_replication_workers == null ? null : var.max_logical_replication_workers
  }
}

dynamic "database_flags" {
  for_each = var.max_parallel_workers != null ? [1] : []
  content {
    name  = "max_parallel_workers"
    value = var.max_parallel_workers == null ? null : var.max_parallel_workers
  }
}

dynamic "database_flags" {
  for_each = var.max_replication_slots != null ? [1] : []
  content {
    name  = "max_replication_slots"
    value = var.max_replication_slots == null ? null : var.max_replication_slots
  }
}
dynamic "database_flags" {
  for_each = var.max_standby_archive_delay != null ? [1] : []
  content {
    name  = "max_standby_archive_delay"
    value = var.max_standby_archive_delay == null ? null : var.max_standby_archive_delay
  }
}

dynamic "database_flags" {
  for_each = var.max_standby_streaming_delay != null ? [1] : []
  content {
    name  = "max_standby_streaming_delay"
    value = var.max_standby_streaming_delay == null ? null : var.max_standby_streaming_delay
  }
}

dynamic "database_flags" {
  for_each = var.max_sync_workers_per_subscription != null ? [1] : []
  content {
    name  = "max_sync_workers_per_subscription"
    value = var.max_sync_workers_per_subscription == null ? null : var.max_sync_workers_per_subscription
  }
}

dynamic "database_flags" {
  for_each = var.max_wal_senders != null ? [1] : []
  content {
    name  = "max_wal_senders"
    value = var.max_wal_senders == null ? null : var.max_wal_senders
  }
}

dynamic "database_flags" {
  for_each = var.max_wal_size != null ? [1] : []
  content {
    name  = "max_wal_size"
    value = var.max_wal_size == null ? null : var.max_wal_size
  }
}

dynamic "database_flags" {
  for_each = var.max_worker_processes != null ? [1] : []
  content {
    name  = "max_worker_processes"
    value = var.max_worker_processes == null ? null : var.max_worker_processes
  }
}

dynamic "database_flags" {
  for_each = var.min_wal_size != null ? [1] : []
  content {
    name  = "min_wal_size"
    value = var.min_wal_size == null ? null : var.min_wal_size
  }
}

dynamic "database_flags" {
  for_each = var.shared_buffers  != null ? [1] : []
  content {
    name  = "shared_buffers"
    value = var.shared_buffers == null ? null : var.shared_buffers
  }
}

dynamic "database_flags" {
  for_each = var.track_commit_timestamp != null ? [1] : []
  content {
    name  = "track_commit_timestamp"
    value = var.track_commit_timestamp == null ? null : var.track_commit_timestamp
  }
}

dynamic "database_flags" {
  for_each = var.wal_buffers != null ? [1] : []
  content {
    name  = "wal_buffers"
    value = var.wal_buffers == null ? null : var.wal_buffers
  }
}

dynamic "database_flags" {
  for_each = var.work_mem != null ? [1] : []
  content {
    name  = "work_mem"
    value = var.work_mem == null ? null : var.work_mem
  }
}

dynamic "database_flags" {
  for_each = var.pg_cron != null ? [1] : []
  content {
    name  = "cloudsql.enable_pg_cron"
    value = var.pg_cron == null ? null : var.pg_cron
  }
}



    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.google_compute_network.private_network.id
      enable_private_path_for_google_cloud_services = true

      psc_config {
        psc_enabled               = false
#        allowed_consumer_projects = [var.gcp_project_id]
      }

    }

  backup_configuration {
#    enabled            = false
    enabled            = true
  }



    availability_type = "REGIONAL"
  }

}


# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "replica_instance" {
  count            = var.replica_count > 0 ? var.replica_count : 0
  name             = "${var.db_instance_name}-replica-${count.index}"
#  name             = var.db_replica_name
  region           = var.gcp_region
  project          = var.gcp_project_id
  database_version = var.db_version
# deletion_protection = true

  // Specify the primary instance to replicate from
  master_instance_name = var.db_instance_name

  // Configure replication settings for the replica instance

  settings {
     tier = var.db_tier
     deletion_protection_enabled = true

    database_flags {
      name  = "cloudsql.logical_decoding"
      value = var.cloudsql_logical_decoding ? "on" : "off"
    }

dynamic "database_flags" {
  for_each = var.autovacuum_vacuum_scale_factor != null ? [1] : []
  content {
    name  = "autovacuum_vacuum_scale_factor"
    value = var.autovacuum_vacuum_scale_factor == null ? null : var.autovacuum_vacuum_scale_factor
  }
}

dynamic "database_flags" {
  for_each = var.autovacuum_analyze_scale_factor != null ? [1] : []
  content {
    name  = "autovacuum_analyze_scale_factor"
    value = var.autovacuum_analyze_scale_factor == null ? null : var.autovacuum_analyze_scale_factor
  }
}


dynamic "database_flags" {
  for_each = var.autovacuum_max_workers != null ? [1] : []
  content {
    name  = "autovacuum_max_workers"
    value = var.autovacuum_max_workers == null ? null : var.autovacuum_max_workers
  }
}


dynamic "database_flags" {
  for_each = var.autovacuum_vacuum_cost_delay != null ? [1] : []
  content {
    name  = "autovacuum_vacuum_cost_delay"
    value = var.autovacuum_vacuum_cost_delay == null ? null : var.autovacuum_vacuum_cost_delay
  }
}


dynamic "database_flags" {
  for_each = var.checkpoint_timeout != null ? [1] : []
  content {
    name  = "checkpoint_timeout"
    value = var.checkpoint_timeout == null ? null : var.checkpoint_timeout
      }
    }

dynamic "database_flags" {
  for_each = var.default_statistics_target != null ? [1] : []
  content {
    name  = "default_statistics_target"
    value = var.default_statistics_target == null ? null : var.default_statistics_target
  }
}

dynamic "database_flags" {
  for_each = var.effective_cache_size != null ? [1] : []
  content {
    name = "effective_cache_size"
    value = var.effective_cache_size == null ? null : var.effective_cache_size
  }
}

dynamic "database_flags" {
  for_each = var.hot_standby_feedback != null ? [1] : []
  content {
    name  = "hot_standby_feedback"
    value = var.hot_standby_feedback == null ? null : var.hot_standby_feedback
  }
}

dynamic "database_flags" {
  for_each = var.log_autovacuum_min_duration != null ? [1] : []
  content {
    name  = "log_autovacuum_min_duration"
    value = var.log_autovacuum_min_duration == null ? null : var.log_autovacuum_min_duration
  }
}

dynamic "database_flags" {
  for_each = var.log_checkpoints != null ? [1] : []
  content {
    name  = "log_checkpoints"
    value = var.log_checkpoints == null ? null : var.log_checkpoints
  }
}

dynamic "database_flags" {
  for_each = var.log_connections != null ? [1] : []
  content {
    name  = "log_connections"
    value = var.log_connections == null ? null : var.log_connections
  }
}

dynamic "database_flags" {
  for_each = var.log_line_prefix != null ? [1] : []
  content {
    name  = "log_line_prefix"
    value = var.log_line_prefix == null ? null : var.log_line_prefix
  }
}

dynamic "database_flags" {
  for_each = var.log_lock_waits != null ? [1] : []
  content {
    name  = "log_lock_waits"
    value = var.log_lock_waits == null ? null : var.log_lock_waits
  }
}

dynamic "database_flags" {
  for_each = var.log_min_duration_statement != null ? [1] : []
  content {
    name  = "log_min_duration_statement"
    value = var.log_min_duration_statement == null ? null : var.log_min_duration_statement
  }
}

dynamic "database_flags" {
  for_each = var.log_statement != null ? [1] : []
  content {
    name  = "log_statement"
    value = var.log_statement == null ? null : var.log_statement
  }
}

dynamic "database_flags" {
  for_each = var.log_temp_files != null ? [1] : []
  content {
    name  = "log_temp_files"
    value = var.log_temp_files == null ? null : var.log_temp_files
  }
}

dynamic "database_flags" {
  for_each = var.maintenance_work_mem != null ? [1] : []
  content {
    name  = "maintenance_work_mem"
    value = var.maintenance_work_mem == null ? null : var.maintenance_work_mem
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
  for_each = var.max_logical_replication_workers  != null ? [1] : []
  content {
    name  = "max_logical_replication_workers"
    value = var.max_logical_replication_workers == null ? null : var.max_logical_replication_workers
  }
}

dynamic "database_flags" {
  for_each = var.max_parallel_workers != null ? [1] : []
  content {
    name  = "max_parallel_workers"
    value = var.max_parallel_workers == null ? null : var.max_parallel_workers
  }
}

dynamic "database_flags" {
  for_each = var.max_replication_slots != null ? [1] : []
  content {
    name  = "max_replication_slots"
    value = var.max_replication_slots == null ? null : var.max_replication_slots
  }
}
dynamic "database_flags" {
  for_each = var.max_standby_archive_delay != null ? [1] : []
  content {
    name  = "max_standby_archive_delay"
    value = var.max_standby_archive_delay == null ? null : var.max_standby_archive_delay
  }
}

dynamic "database_flags" {
  for_each = var.max_standby_streaming_delay != null ? [1] : []
  content {
    name  = "max_standby_streaming_delay"
    value = var.max_standby_streaming_delay == null ? null : var.max_standby_streaming_delay
  }
}

dynamic "database_flags" {
  for_each = var.max_sync_workers_per_subscription != null ? [1] : []
  content {
    name  = "max_sync_workers_per_subscription"
    value = var.max_sync_workers_per_subscription == null ? null : var.max_sync_workers_per_subscription
  }
}

dynamic "database_flags" {
  for_each = var.max_wal_senders != null ? [1] : []
  content {
    name  = "max_wal_senders"
    value = var.max_wal_senders == null ? null : var.max_wal_senders
  }
}

dynamic "database_flags" {
  for_each = var.max_wal_size != null ? [1] : []
  content {
    name  = "max_wal_size"
    value = var.max_wal_size == null ? null : var.max_wal_size
  }
}

dynamic "database_flags" {
  for_each = var.max_worker_processes != null ? [1] : []
  content {
    name  = "max_worker_processes"
    value = var.max_worker_processes == null ? null : var.max_worker_processes
  }
}

dynamic "database_flags" {
  for_each = var.min_wal_size != null ? [1] : []
  content {
    name  = "min_wal_size"
    value = var.min_wal_size == null ? null : var.min_wal_size
  }
}

dynamic "database_flags" {
  for_each = var.shared_buffers  != null ? [1] : []
  content {
    name  = "shared_buffers"
    value = var.shared_buffers == null ? null : var.shared_buffers
  }
}

dynamic "database_flags" {
  for_each = var.track_commit_timestamp != null ? [1] : []
  content {
    name  = "track_commit_timestamp"
    value = var.track_commit_timestamp == null ? null : var.track_commit_timestamp
  }
}

dynamic "database_flags" {
  for_each = var.wal_buffers != null ? [1] : []
  content {
    name  = "wal_buffers"
    value = var.wal_buffers == null ? null : var.wal_buffers
  }
}

dynamic "database_flags" {
  for_each = var.work_mem != null ? [1] : []
  content {
    name  = "work_mem"
    value = var.work_mem == null ? null : var.work_mem
  }
}

dynamic "database_flags" {
  for_each = var.pg_cron != null ? [1] : []
  content {
    name  = "cloudsql.enable_pg_cron"
    value = var.pg_cron == null ? null : var.pg_cron
  }
}

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.google_compute_network.private_network.id
      enable_private_path_for_google_cloud_services = true

      psc_config {
        psc_enabled               = false
#        allowed_consumer_projects = [var.gcp_project_id]
      }

    }
    availability_type = "REGIONAL"
}

  depends_on = [google_sql_database_instance.instance]
}



#resource "random_password" "pwd" {
#  length  = 16
#  special = false
#}


#resource "google_sql_user" "user" {
 # name     = var.db_user_name
 # password = var.db_user_password
 # instance = var.db_instance_name
 # project          = var.gcp_project_id
#}

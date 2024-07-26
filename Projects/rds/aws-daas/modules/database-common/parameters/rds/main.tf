
################################################
# Backend management
################################################
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

## Small 
resource "aws_db_parameter_group" "pg-small" {
#  name   = "postg-pg-small"
  name   = join("-",["ipg",var.db_parameter_family,"small"])
  family = var.db_parameter_family

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,pglogical"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "1000"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_worker_processes"
    value = "30"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_replication_slots"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_wal_senders"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_logical_replication_workers"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_sync_workers_per_subscription"
    value = "3"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_min_duration_statement"
    value = "200"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "autovacuum_max_workers"
    value = "12"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_statement"
    value = "ddl"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "track_commit_timestamp"
    value = "1"
    apply_method = "pending-reboot"
  }

}

## Medium
resource "aws_db_parameter_group" "pg-medium" {
  name   = join("-",["ipg",var.db_parameter_family,"medium"])
  #name   = "postg-pg-medium"
  family = var.db_parameter_family

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,pglogical"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "2000"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_worker_processes"
    value = "30"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_replication_slots"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_wal_senders"
    value = "10"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_logical_replication_workers"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_sync_workers_per_subscription"
    value = "3"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_min_duration_statement"
    value = "200"
    apply_method = "pending-reboot"
  }
  parameter {
    name = "autovacuum_max_workers"
    value = "12"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_statement"
    value = "ddl"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "track_commit_timestamp"
    value = "1"
    apply_method = "pending-reboot"
  }

}

## Large
resource "aws_db_parameter_group" "pg-large" {
  #name   = "postg-pg-large"
  name   = join("-",["ipg",var.db_parameter_family,"large"])
  family = var.db_parameter_family

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,pglogical"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "5000"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_worker_processes"
    value = "30"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_replication_slots"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_wal_senders"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_logical_replication_workers"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_sync_workers_per_subscription"
    value = "3"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_min_duration_statement"
    value = "200"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "autovacuum_max_workers"
    value = "12"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_statement"
    value = "ddl"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "track_commit_timestamp"
    value = "1"
    apply_method = "pending-reboot"
  }

}

## Large
resource "aws_db_parameter_group" "pg-debug" {
  #name   = "postg-pg-large"
  name   = join("-",["ipg",var.db_parameter_family,"debug"])
  family = var.db_parameter_family

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,pglogical"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_connections"
    value = "5000"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_worker_processes"
    value = "30"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_replication_slots"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_wal_senders"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_logical_replication_workers"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_sync_workers_per_subscription"
    value = "3"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_min_duration_statement"
    value = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "autovacuum_max_workers"
    value = "12"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_statement"
    value = "ddl"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "track_commit_timestamp"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "log_autovacuum_min_duration"
    value = "0"
    apply_method = "pending-reboot"
  }
 
  parameter {
    name = "hot_standby_feedback"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_standby_streaming_delay"
    value = "300000"
    apply_method = "pending-reboot"
  }

  parameter {
    name = "max_standby_archive_delay"
    value = "300000"
    apply_method = "pending-reboot"
  }

}

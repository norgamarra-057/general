################################################
# Backend management
################################################
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

## Small 
resource "aws_rds_cluster_parameter_group" "cpg-small" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"small"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "1000"
        apply_method = "pending-reboot"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method",null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
  # 4/feb/22: no cluster level specific param needed for now
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method",null)
    }
  }
}

## Medium 
resource "aws_rds_cluster_parameter_group" "cpg-medium" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"medium"])
  family = var.db_parameter_family
  parameter {
        name = "max_connections"
        value = "2000"
        apply_method = "pending-reboot"
  }
  # 4/feb/22: no cluster level specific param needed for now
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method",null)
    }
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method",null)
    }
  }
}

## Large 
resource "aws_rds_cluster_parameter_group" "cpg-large" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"large"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"   				
	value = "5000"
        apply_method = "pending-reboot"
  }
  # 4/feb/22: no cluster level specific param needed for now
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
}

## Small 
resource "aws_db_parameter_group" "ipg-small" {
  name   = join("-",["ipg",replace(var.db_parameter_family,".",""),"small"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "1000"
        apply_method = "pending-reboot"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }
}

## Medium 
resource "aws_db_parameter_group" "ipg-medium" {
  name   = join("-",["ipg",replace(var.db_parameter_family,".",""),"medium"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "2000"
        apply_method = "pending-reboot"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
}

## Large 
resource "aws_db_parameter_group" "ipg-large" {
  name   = join("-",["ipg",replace(var.db_parameter_family,".",""),"large"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "5000"
        apply_method = "pending-reboot"
  }

  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
}

variable "common_parameters_list" {
  description = "List containing common parameters across all pgs"
  type        = list(map(any))
  default     = [
  {
    name = "log_min_duration_statement"
    value = "200"
    apply_method = "pending-reboot"
  },
  {
    name = "log_statement"
    value = "ddl"
    apply_method = "pending-reboot"
  }
  ]
}

variable "common_parameters_list_cluster" {
  description = "List containing common parameters across all pgs"
  type        = list(map(any))
  default     = [
  {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  },
  {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,pglogical"
    apply_method = "pending-reboot"
  },
  {
    name = "max_worker_processes"
    value = "30"
    apply_method = "pending-reboot"
  },
  {
    name = "max_replication_slots"
    value = "10"
    apply_method = "pending-reboot"
  },
  {
    name = "max_logical_replication_workers"
    value = "6"
    apply_method = "pending-reboot"
  },
  {
    name = "max_sync_workers_per_subscription"
    value = "3"
    apply_method = "pending-reboot"
  },
  {
    name = "max_wal_senders"
    value = "20"
    apply_method = "pending-reboot"
  },
  {
    name = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  },
  {
    name = "autovacuum_max_workers"
    value = "12"
    apply_method = "pending-reboot"
  },
  {
    name = "track_commit_timestamp"
    value = "1"
    apply_method = "pending-reboot"
  },
   ]
}


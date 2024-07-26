################################################
# Backend management
################################################
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

## nolog
resource "aws_rds_cluster_parameter_group" "cpg-nolog" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"small"])
  family = var.db_parameter_family
  parameter {
        name = "binlog_format"
        value = "off"
        apply_method = "pending-reboot"
  }
  parameter {
        name = "max_connections"
        value = "8000"
  }
  parameter {
        name = "event_scheduler"
        value = "ON"
        apply_method = "immediate"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method",null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      apply_method = lookup(parameter.value, "apply_method",null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

## Small 
resource "aws_rds_cluster_parameter_group" "cpg-small" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"small"])
  family = var.db_parameter_family
  parameter {
	name = "binlog_format"
	value = "ROW"
	apply_method = "pending-reboot"
  }
  parameter {
	name = "max_connections"
	value = "8000"
  }
  parameter {
        name = "event_scheduler"
        value = "ON"
        apply_method = "immediate"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method",null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      apply_method = lookup(parameter.value, "apply_method",null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

## Medium 
resource "aws_rds_cluster_parameter_group" "cpg-medium" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"medium"])
  family = var.db_parameter_family
  parameter {
        name = "binlog_format"
        value = "ROW"
        apply_method = "pending-reboot"
  }
  parameter {
        name = "max_connections"
        value = "8000"
  }
  parameter {
        name = "event_scheduler"
        value = "ON"
        apply_method = "immediate"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method",null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      apply_method = lookup(parameter.value, "apply_method",null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}


## Large 
resource "aws_rds_cluster_parameter_group" "cpg-large" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"large"])
  family = var.db_parameter_family
  parameter {
	name = "binlog_format"
	value = "ROW"
	apply_method = "pending-reboot"
  }
  parameter {
	name = "max_connections"   				
	value = "9000"
  }
  parameter {
        name = "event_scheduler"
        value = "ON"
        apply_method = "immediate"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

## Small 
resource "aws_db_parameter_group" "ipg-small" {
  #name   = "ipg-small"
  name   = join("-",["ipg",replace(var.db_parameter_family,".",""),"small"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "8000"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      #apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

## Medium 
resource "aws_db_parameter_group" "ipg-medium" {
  #name   = "ipg-medium"
  name   = join("-",["ipg",replace(var.db_parameter_family,".",""),"medium"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "8000"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

## Large 
resource "aws_db_parameter_group" "ipg-large" {
  #name   = "ipg-large"
  name   = join("-",["ipg",replace(var.db_parameter_family,".",""),"large"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "9000"
  }

  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

variable "common_parameters_list" {
  description = "List containing common parameters across all pgs"
  type        = list(map(any))
  default     = [
	{
          name = "slow_query_log"
          value = "1"
  	},
  	{
          name = "long_query_time"
          value = "0.1"
	},
	{
          name = "max_allowed_packet"
          value = "1073741824"
          apply_method = "immediate"
	},
	{
          name = "group_concat_max_len"
          value = "16384"
          apply_method = "immediate"
	},
       {
          name = "log_bin_trust_function_creators"
          value = "1"
          apply_method = "immediate"
       },
       {
         name = "innodb_sort_buffer_size"
         value = "8388608"
         # test sandbox: value = "10485760"
         apply_method = "pending-reboot"
       }
  ]
}

variable "common_parameters_list_cluster" {
  description = "List containing common parameters across all pgs"
  type        = list(map(any))
  default     = [
       {
          name = "character_set_server"
          value = "utf8"
          apply_method = "pending-reboot"
       },
        {
          name = "character_set_database"
          value = "utf8"
          apply_method = "pending-reboot"
        },
        {
          name = "character_set_client"
          value = "utf8"
          apply_method = "immediate"
        },
        {
          name = "character_set_connection"
          value = "utf8"
          apply_method = "immediate"
        },
        {
          name = "character_set_results"
          value = "utf8"
          apply_method = "immediate"
        },
        {
          name = "collation_server"
          value = "utf8_general_ci"
          apply_method = "pending-reboot"
        },
        {
          name = "explicit_defaults_for_timestamp"
          value = "0"
          apply_method = "pending-reboot"
        },
        {
          name = "collation_connection"
          value = "utf8_general_ci"
          apply_method = "immediate"
       },
   ]
}


## Cluster Parameter Group with binlog disabled
resource "aws_rds_cluster_parameter_group" "cpg-medium-nobinlog" {
  name   = join("-",["cpg",replace(var.db_parameter_family,".",""),"nobinlog"])
  family = var.db_parameter_family
  parameter {
	name = "binlog_format"
	value = "OFF"
	apply_method = "pending-reboot"
  }
  parameter {
	name = "max_connections"
	value = "8000"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list_cluster
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

resource "aws_db_parameter_group" "ipg-medium-nobinlog" {
  name   = join("-",["ipg",replace(var.db_parameter_family,".",""),"nobinlog"])
  family = var.db_parameter_family
  parameter {
	name = "max_connections"
	value = "8000"
  }
  dynamic "parameter" {
    for_each = var.common_parameters_list
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value["name"]
      value        = parameter.value["value"]
    }
  }
}

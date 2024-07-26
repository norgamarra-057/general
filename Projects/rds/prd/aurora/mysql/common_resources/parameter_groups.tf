## Small us-west-1
resource "aws_rds_cluster_parameter_group" "cpg-west1-s" {
  name   = "cpg-small"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest1"

  parameter {
    name  = "max_connections"
    value = "998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Medium us-west-1
resource "aws_rds_cluster_parameter_group" "cpg-west1-m" {
  name   = "cpg-medium"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest1"

  parameter {
    name  = "max_connections"
    value = "3998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Large us-west-1
resource "aws_rds_cluster_parameter_group" "cpg-west1-l" {
  name   = "cpg-large"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest1"

  parameter {
    name  = "max_connections"
    value = "7998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

### -----------------------------------------

## Small eu-west-1
resource "aws_rds_cluster_parameter_group" "cpg-euwest1-s" {
  name   = "cpg-small"
  family = "aurora-mysql5.7"
  provider    = "aws.euwest1"

  parameter {
    name  = "max_connections"
    value = "998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Medium eu-west-1
resource "aws_rds_cluster_parameter_group" "cpg-euwest1-m" {
  name   = "cpg-medium"
  family = "aurora-mysql5.7"
  provider    = "aws.euwest1"

  parameter {
    name  = "max_connections"
    value = "3998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Large eu-west-1
resource "aws_rds_cluster_parameter_group" "cpg-euwest1-l" {
  name   = "cpg-large"
  family = "aurora-mysql5.7"
  provider    = "aws.euwest1"

  parameter {
    name  = "max_connections"
    value = "7998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}
## Small us-west-1
resource "aws_db_parameter_group" "ipg-west1-s" {
  name   = "ipg-small"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest1"

  parameter {
    name  = "max_connections"
    value = "998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}

## Medium us-west-1
resource "aws_db_parameter_group" "ipg-west1-m" {
  name   = "ipg-medium"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest1"

  parameter {
    name  = "max_connections"
    value = "3998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}

## Large us-west-1
resource "aws_db_parameter_group" "ipg-west1-l" {
  name   = "ipg-large"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest1"

  parameter {
    name  = "max_connections"
    value = "7998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}

### -----------------------------------------

## Small eu-west-1
resource "aws_db_parameter_group" "ipg-euwest1-s" {
  name   = "ipg-small"
  family = "aurora-mysql5.7"
  provider    = "aws.euwest1"

  parameter {
    name  = "max_connections"
    value = "998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}

## Medium eu-west-1
resource "aws_db_parameter_group" "ipg-euwest1-m" {
  name   = "ipg-medium"
  family = "aurora-mysql5.7"
  provider    = "aws.euwest1"

  parameter {
    name  = "max_connections"
    value = "3998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}

## Large eu-west-1
resource "aws_db_parameter_group" "ipg-euwest1-l" {
  name   = "ipg-large"
  family = "aurora-mysql5.7"
  provider    = "aws.euwest1"

  parameter {
    name  = "max_connections"
    value = "7998"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}


### -----------------------------------------
## Large us-west-1 v5.6
resource "aws_rds_cluster_parameter_group" "cpg-west1-56-l" {
  name   = "cpg-56-large"
  family = "aurora5.6"
  provider    = "aws.uswest1"

  parameter {
    name  = "max_connections"
    value = "8000"
  }

  parameter {
    name  = "max_user_connections"
    value = "7980"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Large eu-west-1 v5.6
resource "aws_rds_cluster_parameter_group" "cpg-euwest1-56-l" {
  name   = "cpg-56-large"
  family = "aurora5.6"
  provider    = "aws.euwest1"

  parameter {
    name  = "max_connections"
    value = "8000"
  }

  parameter {
    name  = "max_user_connections"
    value = "7980"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = ".02"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
  parameter {
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Large us-west-1 v5.6
resource "aws_db_parameter_group" "ipg-uswest1-56-l" {
  name   = "ipg-56-large"
  family = "aurora5.6"
  provider    = "aws.uswest1"


  parameter {
    name  = "max_connections"
    value = "8000"
  }

  parameter {
    name  = "max_user_connections"
    value = "7980"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}

## Large eu-west-1 v5.6
resource "aws_db_parameter_group" "ipg-euwest1-56-l" {
  name   = "ipg-56-large"
  family = "aurora5.6"
  provider    = "aws.euwest1"


  parameter {
    name  = "max_connections"
    value = "8000"
  }

  parameter {
    name  = "max_user_connections"
    value = "7980"
  }

  parameter {
    name  = "autocommit"
    value = "1"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
}

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
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

### -----------------------------------------

## Small us-west-2
resource "aws_rds_cluster_parameter_group" "cpg-uswest2-s" {
  name   = "cpg-small"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest2"

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
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Medium us-west-2
resource "aws_rds_cluster_parameter_group" "cpg-uswest2-m" {
  name   = "cpg-medium"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest2"

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
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Large us-west-2
resource "aws_rds_cluster_parameter_group" "cpg-uswest2-l" {
  name   = "cpg-large"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest2"

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

## Large us-west-1
resource "aws_db_parameter_group" "ipg-west1-l" {
  name   = "ipg-large"
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

### -----------------------------------------

## Small us-west-2
resource "aws_db_parameter_group" "ipg-uswest2-s" {
  name   = "ipg-small"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest2"

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

## Medium us-west-2
resource "aws_db_parameter_group" "ipg-uswest2-m" {
  name   = "ipg-medium"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest2"

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

## Large us-west-2
resource "aws_db_parameter_group" "ipg-uswest2-l" {
  name   = "ipg-large"
  family = "aurora-mysql5.7"
  provider    = "aws.uswest2"

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
   name = "innodb_autoinc_lock_mode"
   value = "2"
   apply_method = "pending-reboot"
  }
}

## Large us-west-2 v5.6
resource "aws_rds_cluster_parameter_group" "cpg-uswest2-56-l" {
  name   = "cpg-56-large"
  family = "aurora5.6"
  provider    = "aws.uswest2"

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
   name = "innodb_autoinc_lock_mode"
   value = "2"
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

## Large us-west-2 v5.6
resource "aws_db_parameter_group" "ipg-uswest2-56-l" {
  name   = "ipg-56-large"
  family = "aurora5.6"
  provider    = "aws.uswest2"


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

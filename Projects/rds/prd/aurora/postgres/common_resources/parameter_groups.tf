## Small west1
resource "aws_rds_cluster_parameter_group" "cpg-west1-s" {
  name   = "cpg-small"
  family = "aurora-postgresql10"
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
}

## Medium west1
resource "aws_rds_cluster_parameter_group" "cpg-west1-m" {
  name   = "cpg-medium"
  family = "aurora-postgresql10"
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
}

## Large west1
resource "aws_rds_cluster_parameter_group" "cpg-west1-l" {
  name   = "cpg-large"
  family = "aurora-postgresql10"
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
}

### -----------------------------------------

## Small east1
resource "aws_rds_cluster_parameter_group" "cpg-east1-s" {
  name   = "cpg-small"
  family = "aurora-postgresql10"
  provider    = "aws.useast1"

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
}

## Medium east1
resource "aws_rds_cluster_parameter_group" "cpg-east1-m" {
  name   = "cpg-medium"
  family = "aurora-postgresql10"
  provider    = "aws.useast1"

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
}

## Large east1
resource "aws_rds_cluster_parameter_group" "cpg-east1-l" {
  name   = "cpg-large"
  family = "aurora-postgresql10"
  provider    = "aws.useast1"

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
}

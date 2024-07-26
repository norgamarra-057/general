## Small west1
resource "aws_db_parameter_group" "pg-west1-s" {
  name   = "postg-pg-small"
  family = "postgres10"
  provider    = "aws.uswest1"

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "250"
    apply_method = "pending-reboot"
  }
}

## Medium west1
resource "aws_db_parameter_group" "pg-west1-m" {
  name   = "postg-pg-medium"
  family = "postgres10"
  provider    = "aws.uswest1"

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "250"
    apply_method = "pending-reboot"
  }
}

## Large west1
resource "aws_db_parameter_group" "pg-west1-l" {
  name   = "postg-pg-large"
  family = "postgres10"
  provider    = "aws.uswest1"

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "250"
    apply_method = "pending-reboot"
  }
}

### -----------------------------------------

## Small west2
resource "aws_db_parameter_group" "pg-west2-s" {
  name   = "postg-pg-small"
  family = "postgres10"
  provider    = "aws.uswest2"

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "250"
    apply_method = "pending-reboot"
  }
}

## Medium west2
resource "aws_db_parameter_group" "pg-west2-m" {
  name   = "postg-pg-medium"
  family = "postgres10"
  provider    = "aws.uswest2"

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "250"
    apply_method = "pending-reboot"
  }
}

## Large west2
resource "aws_db_parameter_group" "pg-west2-l" {
  name   = "postg-pg-large"
  family = "postgres10"
  provider    = "aws.uswest2"

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
    apply_method = "pending-reboot"
  }
   
  parameter {
    name = "max_connections"
    value = "250"
    apply_method = "pending-reboot"
  }
}


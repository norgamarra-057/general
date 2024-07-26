provider "postgresql" {
	host = var.cluster_master_arn == "" ? aws_rds_cluster.master[0].endpoint : aws_rds_cluster.replica[0].endpoint
	port = var.port
	database = var.db_name
	username = var.admin_username
	password = var.admin_password
	sslmode = "require"
	#connect_timeout = 15
	expected_version = var.engine_version
}

#resource "postgresql_extension" "pglogical_extensions" {
#  count = contains(var.extensions,"pglogical") ? 1 : 0
#  name = "pglogical"
#  database = var.db_name
#}

#resource "postgresql_extension" "pg_stat_statements_extensions" {
#  count = contains(var.extensions,"pg_stat_statements") ? 1 : 0
#  name = "pg_stat_statements"
#  database = var.db_name
#}

resource "postgresql_extension" "pg_extensions" {
  count = length(var.extensions)
  name = var.extensions[count.index]
  database = var.db_name
}

#provider "postgresql" {
#    host = aws_db_instance.master.address
#    username = var.admin_username
#    password = var.admin_password
#    database = aws_db_instance.master.name
#}
#
#resource "postgresql_role" "checkmk_mon" {
#  name = "checkmk_mon"
#  replication = false
#  login = true
#  connection_limit = 10
#  password = "Chdknf9h240"
#}
#
#resource postgresql_grant "checkmk_mon_grant_1" {
#  role = "checkmk_mon"
#  database = "postgres"
#  schema = "pglogical"
#  object_type = "schema"
#  privileges = ["USAGE"]
#}
#resource postgresql_grant "checkmk_mon_grant_2" {
#  role = "checkmk_mon"
#  database = "postgres"
#  schema = "dba"
#  object_type = "schema"
#  privileges = ["USAGE"]
#}
#resource postgresql_grant "checkmk_mon_grant_3" {
#  role = "checkmk_mon"
#  database = "postgresql"
#  schema = 
#  object_type = 
#  privileges = ["pg_read_all_stats"]
#}
#resource postgresql_grant "checkmk_mon_grant_4" {
#  role = "checkmk_mon"
#  database = "aws"
#  schema = "dba"
#  object_type = "table"
#  privileges = ["SELECT"]
#}
#resource postgresql_grant "checkmk_mon_grant_5" {
#  role = "checkmk_mon"
#  database = "postgres"
#  schema = "heartbeat"
#  object_type = "schema"
#  privileges = ["USAGE"]
#}
#resource postgresql_grant "checkmk_mon_grant_6" {
#  role = "checkmk_mon"
#  database = "postgres"
#  schema = "heartbeat"
#  object_type = "table"
#  privileges = ["SELECT"]
#}

#provider "mysql" {
#  endpoint = var.instance == "" ? google_sql_database_instance.instance.ip_address : google_sql_database_instance.read_replica[0].ip_address
#  username = var.admin_username
#  password = var.admin_password
#}

#resource "mysql_user" "replication_user" {
#  count              = var.instance == "" ? 1 : 0
#  user               = "replication"
#  host               = "%"
#  plaintext_password = "GaSxrz1twblgEyl"
#}

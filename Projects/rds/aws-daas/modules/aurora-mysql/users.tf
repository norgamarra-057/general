provider "mysql" {
    endpoint = var.cluster_master_arn == "" ? aws_rds_cluster.master[0].endpoint : aws_rds_cluster.replica[0].endpoint
    username = var.admin_username
    password = var.admin_password
}

resource "mysql_user" "replication_user" {
  count              = var.cluster_master_arn == "" ? 1 : 0
  user               = "replication"
  host               = "%"
  plaintext_password = "GaSxrz1twblgEyl"
}

resource "mysql_grant" "replication_grant" {
  count      = var.cluster_master_arn == "" ? 1 : 0
  user       = mysql_user.replication_user[count.index].user
  host       = mysql_user.replication_user[count.index].host
  database   = "*"
  privileges = ["REPLICATION SLAVE", "REPLICATION CLIENT"]
}

resource "mysql_user" "checkmk_mon" {
  count              = var.cluster_master_arn == "" ? 1 : 0
  user               = "checkmk_mon"
  host               = "%"
  plaintext_password = "Chdknf9h2404fdsrds"
}

resource "mysql_grant" "checkmk_mon_grant_1" {
  count      = var.cluster_master_arn == "" ? 1 : 0
  user       = mysql_user.checkmk_mon[count.index].user
  host       = mysql_user.checkmk_mon[count.index].host
  database   = "*"
  privileges = ["PROCESS", "REPLICATION CLIENT"]
}

resource "mysql_grant" "checkmk_mon_grant_2" {
  count      = var.cluster_master_arn == "" ? 1 : 0
  user       = mysql_user.checkmk_mon[count.index].user
  host       = mysql_user.checkmk_mon[count.index].host
  database   = "percona"
  privileges = ["SELECT"]
}

resource "mysql_grant" "checkmk_mon_grant_3" {
  count      = var.cluster_master_arn == "" ? 1 : 0
  user       = mysql_user.checkmk_mon[count.index].user
  host       = mysql_user.checkmk_mon[count.index].host
  database   = "mysql"
  privileges = ["SELECT"]
}

resource "mysql_grant" "checkmk_mon_grant_4" {
  count      = var.cluster_master_arn == "" ? 1 : 0
  user       = mysql_user.checkmk_mon[count.index].user
  host       = mysql_user.checkmk_mon[count.index].host
  database   = "performance_schema"
  privileges = ["SELECT"]
}

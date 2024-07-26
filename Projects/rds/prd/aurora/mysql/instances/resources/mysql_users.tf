#provider "mysql" {
#    endpoint = "${aws_rds_cluster_instance.cluster_instances.0.endpoint}"
#    username = "${var.admin_username}"
#    password = "${var.admin_password}"
#}

#resource "mysql_user" "ro_user" {
#  user               = "ro_user"
#  host               = "%"
#  plaintext_password = "S3Cre7pAss!"
#}

#resource "mysql_grant" "ro_user" {
#  user       = "${mysql_user.ro_user.user}"
#  host       = "${mysql_user.ro_user.host}"
#  database   = "${var.instance_name}"
#  privileges = ["SELECT"]
#}
#
#resource "mysql_user" "rw_user" {
#  user               = "rw_user"
#  host               = "%"
#  plaintext_password = "S3Cre7pAss!"
#}
#
#resource "mysql_grant" "rw_user" {
#  user       = "${mysql_user.rw_user.user}"
#  host       = "${mysql_user.rw_user.host}"
#  database   = "${var.instance_name}"
#  privileges = ["SELECT","UPDATE","DELETE","INSERT"]
#}

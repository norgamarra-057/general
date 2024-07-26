
variable "engine" {
  default = "mysql"

}

variable "engine_version"  {
  default = "5.7.17"
}

variable "major_engine_version" {
  default = "5.7"
}

variable "db_options" {
  type = "list"
  default = [
    { option_name = "MARIADB_AUDIT_PLUGIN"
      option_settings = [
        { name = "SERVER_AUDIT_EVENTS"           value = "CONNECT" },
        { name = "SERVER_AUDIT_FILE_ROTATIONS"   value = "37" }
      ]
    }
  ]
}


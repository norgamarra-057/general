variable "backup_vault" {}

variable "backup_plan_name" {}

variable "backup_cron" {}

#variable "cold_storage_after" {}

#variable "delete_after" {}

variable "tag_key" {}

variable "tag_value" {}

variable "resources_list" {
  type = list
}

variable "lc_options" {
  type = list
}

variable "db_parameter" {
  type = "list"
  default = [
    {name = "myisam_sort_buffer_size",   value = "1048576"},
    {name = "sort_buffer_size",          value = "2097152"},
  ]
}

variable "db_parameter_family" {}

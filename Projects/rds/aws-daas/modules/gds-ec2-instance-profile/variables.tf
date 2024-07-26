// this var is defined in your envs/<env>/<region> directory
// To make it usable in your module you need to define an input variable
variable "aws_region" {
  description = "In which region to create the instances"
}

variable "aws_account_id" {}

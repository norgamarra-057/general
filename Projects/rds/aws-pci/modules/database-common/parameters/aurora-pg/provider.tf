variable "aws_region" {
  description = "Which AWS region the instance is in"
  type        = string
}

variable "aws_region_sec" {
  description = "Secondary region"
  type        = string
}

## Define different AWS providers in case you want, for example, create resources in different regions

# A default provider needs to exist to avoid errors
provider "aws" {
   region     = var.aws_region
}

provider "aws" {
   region     = var.aws_region_sec
   alias      = "secregion"
}

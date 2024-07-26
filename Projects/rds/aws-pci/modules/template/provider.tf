## Define different AWS providers in case you want, for example, create resources in different regions

terraform {
  backend "s3" {}
}

# A default provider needs to exist to avoid errors
provider "aws" {
   version = "~> 3.66"
   region     = var.aws_region
}

provider "aws" {
   region     = var.aws_region_sec
   alias      = "secregion"
}

terraform {
  required_version = "0.12.31"
}

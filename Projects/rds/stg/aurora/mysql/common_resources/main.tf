
## Persist terraform state in S3. Also, use a DynamoDB table to handle locking.

terraform {
  backend "s3" {
    bucket = "gds-rds-terraform-state"
    key    = "parameter-groups-state"
    region = "us-west-1"
    dynamodb_table = "daas-terraform-lock-table"
  }
}



## Define different AWS providers in case you want, for example, create resources in different regions

provider "aws" {
   region     = "us-west-1"
   alias      = "uswest1"
}

provider "aws" {
   region     = "us-west-2"
   alias      = "uswest2"
}

provider "aws" {
   region     = "eu-west-1"
   alias      = "euwest1"
}




# RDS Terraform configuration - Groupon


## Summary

This repository stores the files required to provision RDS environments in AWS for both MySQL and Postgres


## Documentation

The main documentation for provisioning and deploying database changes is on Confluence.  Please see the [Provisioning AWS RDS PostgreSQL Instance](https://groupondev.atlassian.net/wiki/spaces/GDSI/pages/21023119241/Provisioning+AWS+RDS+PostgreSQL+Instance) under the GDS section.

**NOTE:** The documentation below is out of date and needs to be cleaned up. Please see the Confluence documentation above first before looking through the docs below.


## Repository layout

The repository directory structure is the following:

1. At the root, we will find **a directory for each environment** (prod, staging, etc). Each of this branches will have a similar structure, but object IDs will correspond with the AWS role

2. At a second level we can find:

    2.a. **Common resources**, which will be used for both Standard RDS (rds) or Aurora (aurora). These resources are basically security groups and subnet groups
    
    2.b. A branch for **RDS** deployments and another for **Aurora**
    
3. The third level will have a branch for **MySQL** deployments and another for **Postgres**.


4. The fourth level holds:
    3.a) **Cross database technlogy objects** like, in this case, parameter groups
    3.b) **Database instances definitions**
    
Below is the full directory structure

```
stg
stg/common_resources
stg/rds
stg/rds/postgres
stg/rds/postgres/common_resources
stg/rds/postgres/instances
stg/aurora
stg/aurora/postgres
stg/aurora/postgres/common_resources
stg/aurora/postgres/instances
stg/aurora/mysql
stg/aurora/mysql/common_resources
stg/aurora/mysql/instances
prd
prd/common_resources
prd/rds
prd/rds/postgres
prd/rds/postgres/common_resources
prd/rds/postgres/instances
prd/aurora
prd/aurora/postgres
prd/aurora/postgres/common_resources
prd/aurora/postgres/instances
prd/aurora/mysql
prd/aurora/mysql/common_resources
prd/aurora/mysql/instances
```

## Usage

### (A) Make sure you are running Terraform version < 0.12

Version 0.12 doesn't work as it seems there is a conflict with how aws providers are defined at the rds-instance module. The following error is returned for each cluster and instance resource:

```
Error: Provider configuration not present

To work with module.rds-instance.aws_rds_cluster.replica its original provider
configuration at module.rds-instance.provider.aws.remote_region is required,
but it has been removed. This occurs when a provider configuration is removed
while objects created by that provider still exist in the state. Re-add the
provider configuration to destroy module.rds-instance.aws_rds_cluster.replica,
after which you can remove the provider configuration again.

```


### (B) Choose a environment

You just need to enter the appropriate first level directory: i.e. prod, stg

<br>

### (C) Create global objects (Subnet groups and security groups)


#### (C.1) Review main.tf for S3 bucket, locks table and AWS providers

Make sure the S3 bucket exists and that you have access. Also validate that the DynamoDB table used for locking exists and that it has the LockID key. Finally, make sure that there is an aws provider block for each required region.

#### (C.2) Review variables.tf for the appropriate subnet and VPC IDs

Make sure that an entry in each map exist, having the region as a key and the object IDs as values:

```
variable "region_to_subnets_map" {
  type = "map"
  default = {
    us-west-1    = ["subnet-xxxxxxxxxxx", "subnet-yyyyyyyyyyy"]
    eu-west-1    = ["subnet-zzzzzzzzzzz", "subnet-uuuuuuuuuuu","subnet-vvvvvvvvvv"]
  }
}

variable "region_to_vpcid_map" {
  type = "map"
  default = {
    us-west-1    = "vpc-yyyyyyyyyyyyyyy"
    eu-west-1    = "vpc-xxxxxxxxxxxxxxx"
  }
}

```

#### (C.3) Initialize Terraform and apply changes

```
$ terraform init
$ terraform apply
```

### (D) Choose the database technology

Just `cd` to the appropriate directory: i.e. for Aurora MySQL change directory to `aurora/mysql`
<br>


### (E) Create DB engine common objects (parameter groups)

Inside the `common_resources` directory, initialize and apply the Terraform configuration:

```
$ terraform init
$ terraform apply
```


### (F) Create the DB instances

To create the database instances, first change directory to `instances` and then execute the steps below.

#### (F.1) Initialize Terraform configuration

```
$ terraform init
```
#### (F.2) Create workspaces

For each different instance (orders-emea, pwa-us, etc) a specific workspace should be created running the following:
```
$ terraform workspace new orders-emea
```
#### (F.3) Set the appropriate parameters for the workspace

Each workspace could have a different configuration by modifying the maps in `variables.tf`:

```
variable "workspace_to_environment_map" {
  type = "map"
  default = {
    orders-emea = "orders-emea"
    pwa-us      = "pwa-us"
  }
}

variable "environment_to_insttype_map" {
  type = "map"
  default = {
    orders-emea = "db.t2.small"
    pwa-us      = "db.t2.small"
  }
}

variable "environment_to_primary_region_map" {
  type = "map"
  default = {
    orders-emea = "us-west-1"
    pwa-us      = "eu-west-1"
  }
}

variable "environment_to_remote_region_map" {
  type = "map"
  default = {
    orders-emea = "eu-west-1"
    pwa-us      = "us-west-1"
  }
}

variable "environment_to_size_map" {
  type = "map"
  default = {
    orders-emea = "small"
    pwa-us      = "medium"
  }
}

variable "environment_to_dbname_map" {
  type = "map"
  default = {
    orders-emea = "ordersemeadb"
    pwa-us      = "pwausdb"
  }
}
  
```

#### (F.4) Select the workspace you want to use and launch the configuration

Always remember to set the right workspace before launching a set of instances. Keep in mind that the admin password will be requested when `terraform apply` is executed

```
$ terraform workspace select orders-emea
$ terraform apply  
```


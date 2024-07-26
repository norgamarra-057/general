terraform {
    source = "../../../../../../modules/aurora-mysql"
}

include {
	path = find_in_parent_folders()
}

dependencies {
	paths = [
  		"../../../database/networking",
#     	"../../../database/options",
  		"../../../database/parameters/aurora/5.6",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

## Parameters hints:
# * engine: this should be equal to aurora if we want to use v5.6 or aurora-mysql if we want a 5.7 cluster
# * engine_version: if none is provided, the last available version will be used by default
# * cluster_master_arn: this parameter is used when creating a cross-region replica and it should be equal to the master instance Amazon Resource Name.

inputs = {
  instance_type       = "db.t2.small"
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "testdb"
  engine			  = "aurora"
  engine_version	  = ""
  cluster_master_arn  = ""
}

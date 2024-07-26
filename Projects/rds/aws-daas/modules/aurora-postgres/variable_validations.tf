variable "instance_type" {
	description = "Instance type to use for the RDS instances"
	validation {
		condition     = contains(["db.r5.12xlarge","db.r5.16xlarge","db.r5.24xlarge","db.r5.2xlarge","db.r5.4xlarge","db.r5.8xlarge","db.r5.large","db.r5.xlarge","db.r6g.12xlarge","db.r6g.16xlarge","db.r6g.2xlarge","db.r6g.4xlarge","db.r6g.8xlarge","db.r6g.large","db.r6g.xlarge","db.t3.large","db.t3.medium","db.t4g.large","db.t4g.medium"],var.instance_type)
		error_message = "ERROR: The instance type is not valid for engine aurora-postgresql version 13.4 in region us-west-1."
	}
}

variable "workspace_to_environment_map" {
  type = "map"
  default = {
    vis-prod     = "vis-prod"
    pricing-prod     = "pricing-prod"
    m3-merchantdata-prod     = "m3-merchantdata-prod"
    glive-inventory-prod = "glive-inventory-prod"
    pwa-prod = "pwa-prod"
    vis20-emea-prod = "vis20-emea-prod"
    vis20-us-prod = "vis20-us-prod"
    vis20-na-prod = "vis20-na-prod"
    pwa-cluster-prod = "pwa-cluster-prod"
    client-id-prod = "client-id-prod"
  }
}

variable "environment_to_insttype_map" {
  type = "map"
  default = {
    vis-prod     = "db.r5.large"
    pricing-prod     = "db.r5.xlarge"
    m3-merchantdata-prod     = "db.r5.large"
    glive-inventory-prod = "db.r5.large"
    pwa-prod = "db.r5.xlarge"
    vis20-emea-prod = "db.r5.large"
    vis20-us-prod = "db.r5.large"
    vis20-na-prod = "db.r5.large"
    pwa-cluster-prod = "db.r5.xlarge"
    client-id-prod = "db.r5.large"
  }
}

variable "environment_to_engine_map" {
  type = "map"
  default = {
    vis-prod     = "aurora-mysql"
    pricing-prod     =  "aurora-mysql"
    m3-merchantdata-prod     =  "aurora-mysql"
    glive-inventory-prod =  "aurora-mysql"
    pwa-prod =  "aurora-mysql"
    vis20-emea-prod =  "aurora-mysql"
    vis20-us-prod =  "aurora-mysql"
    vis20-na-prod =  "aurora-mysql"
    pwa-cluster-prod =  "aurora"
    client-id-prod =  "aurora-mysql"
  }
}

variable "environment_to_engine_version_map" {
  type = "map"
  default = {
    vis-prod     = "5.7.12"
    pricing-prod     =  "5.7.12"
    m3-merchantdata-prod     =  "5.7.12"
    glive-inventory-prod =  "5.7.12"
    pwa-prod =  "5.7.12"
    vis20-emea-prod =  "5.7.12"
    vis20-us-prod =  "5.7.12"
    vis20-na-prod =  "5.7.12"
    pwa-cluster-prod =  "5.6.10a"
    client-id-prod =  "5.7.mysql_aurora.2.04.6"
  }
}

variable "environment_to_primary_region_map" {
  type = "map"
  default = {
    vis-prod    = "us-west-1"
    pricing-prod    = "us-west-1"
    m3-merchantdata-prod    = "us-west-1"
    glive-inventory-prod = "us-west-1"
    pwa-prod = "us-west-1"
    vis20-emea-prod = "eu-west-1"
    vis20-us-prod = "us-west-1"
    vis20-na-prod = "us-west-1"
    pwa-cluster-prod = "us-west-1"
    client-id-prod = "us-west-1"
  }
}

variable "environment_to_remote_region_map" {
  type = "map"
  default = {
    vis-prod    = "eu-west-1"
    pricing-prod    = "eu-west-1"
    m3-merchantdata-prod    = "eu-west-1"
    glive-inventory-prod = "eu-west-1"
    pwa-prod = "eu-west-1"
    vis20-emea-prod = "us-west-2"
    vis20-us-prod = "us-west-2"
    vis20-na-prod = "us-west-2"
    vis20-emea-prod = "us-west-1"
    vis20-us-prod = "eu-west-1"
    vis20-na-prod = "eu-west-1"
    pwa-cluster-prod = "eu-west-1"
    client-id-prod = "eu-west-1"
  }
}

variable "environment_to_size_map" {
  type = "map"
  default = {
    vis-prod    = "large"
    pricing-prod    = "large"
    m3-merchantdata-prod    = "large"
    glive-inventory-prod = "large"
    pwa-prod = "large"
    vis20-emea-prod = "large"
    vis20-us-prod = "large"
    vis20-na-prod = "large"
    pwa-cluster-prod = "56-large"
    client-id-prod = "large"
  }
}

variable "environment_to_dbname_map" {
  type = "map"
  default = {
    vis-prod    = "voucherinventory_prod"
    pricing-prod    = "pricing_prod"
    m3-merchantdata-prod    = "merchantservice"
    glive-inventory-prod = "glive_inventory_production"
    pwa-prod = "pwa_prod"
    vis20-emea-prod = "vis20_emea_prod"
    vis20-us-prod = "vis20_us_prod"
    vis20-na-prod = "vis20_na_prod"
    pwa-cluster-prod = ""
    client-id-prod = "client_id_prod"
  }
}

variable "environment_to_remote_replica_map" {
  type = "map"
  default = {
    vis-prod             = 1
    pricing-prod         = 1
    m3-merchantdata-prod = 1
    glive-inventory-prod = 1
    pwa-prod             = 1
    vis20-emea-prod      = 0
    vis20-us-prod      = 0
    vis20-na-prod      = 0
    pwa-cluster-prod = 1
    client-id-prod = 1
  }
}

variable "environment_to_local_replica_cnt_map" {
  type = "map"
  default = {
    vis-prod             = 1
    pricing-prod         = 10
    m3-merchantdata-prod = 1
    glive-inventory-prod = 1
    pwa-prod             = 0
    vis20-emea-prod      = 1
    vis20-us-prod      = 1
    vis20-na-prod      = 0
    pwa-cluster-prod = 1
    client-id-prod = 1
  }
}

variable "environment_to_remote_replica_cnt_map" {
  type = "map"
  default = {
    vis-prod             = 1
    pricing-prod         = 10
    m3-merchantdata-prod = 1
    glive-inventory-prod = 1
    pwa-prod = 0
    vis20-emea-prod      = 0
    vis20-us-prod      = 0
    vis20-na-prod      = 0
    pwa-cluster-prod = 1
    client-id-prod = 1
  }
}

variable "adminpassword" {}

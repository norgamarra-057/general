variable "workspace_to_environment_map" {
  type = "map"
  default = {
    gciciliani     = "gciciliani"
    client-id-stg = "client-id-stg"
    glive-inventory-stg = "glive-inventory-stg"
    merchant-stg = "merchant-stg"
    vis20-emea-stg = "vis20-emea-stg"
    pwa3-stg = "pwa3-stg"
    pwa4-stg = "pwa4-stg"
    pricing-service-stg = "pricing-service-stg"
    pwa2-stg = "pwa2-stg"
    pwa-stg = "pwa-stg"
    pricing-service-cluster-stg = "pricing-service-cluster-stg"
    vis-stg = "vis-stg"
    jdoenhardt-mysql-test = "jdoenhardt-mysql-test"
    vis20-us-stg = "vis20-us-stg"
  }
}

variable "environment_to_insttype_map" {
  type = "map"
  default = {
    gciciliani     = "db.t2.small"
    client-id-stg = "db.t2.small"
    glive-inventory-stg = "db.t3.small"
    merchant-stg = "db.t3.small"
    vis20-emea-stg = "db.t2.large"
    pwa3-stg = "db.r5.4xlarge"
    pwa4-stg = "db.r5.xlarge"
    pricing-service-stg = "db.r5.xlarge"
    pwa2-stg = "db.r5.4xlarge"
    pwa-stg = "db.r5.large"
    pricing-service-cluster-stg = "db.r5.12xlarge"
    vis-stg = "db.r3.large"
    jdoenhardt-mysql-test = "db.t2.small"
    vis20-us-stg = "db.t3.medium"
  }
}

variable "environment_to_primary_region_map" {
  type = "map"
  default = {
    gciciliani    = "us-west-1"
    client-id-stg  = "us-west-1"
    glive-inventory-stg = "db.t3.small"
    merchant-stg = "db.t3.small"
    vis20-emea-stg = "us-west-2"
    pwa3-stg = "us-west-1"
    pwa4-stg = "us-west-1"
    pricing-service-stg = "us-west-1"
    pwa2-stg = "us-west-1"
    pwa-stg = "us-west-1"
    pricing-service-cluster-stg = "us-west-1"
    vis-stg = "us-west-1"
    jdoenhardt-mysql-test = "us-west-1"
    vis20-us-stg = "us-west-1"
  }
}

variable "environment_to_remote_region_map" {
  type = "map"
  default = {
    gciciliani    = "us-west-2"
    client-id-stg  = "us-west-2"
    glive-inventory-stg = "us-west-2"
    merchant-stg = "us-west-2"
    vis20-emea-stg = "us-west-1"
    pwa3-stg = "us-west-2"
    pwa4-stg = "us-west-2"
    pricing-service-stg = "us-west-2"
    vis20-us-stg = "us-west-2"
    pwa2-stg = "us-west-2"
    pwa-stg = "us-west-2"
    pricing-service-cluster-stg = "us-west-2"
    vis-stg = "us-west-2"
    jdoenhardt-mysql-test = "us-west-2"
    vis20-us-stg = "us-west-2"
  }
}

variable "environment_to_size_map" {
  type = "map"
  default = {
    gciciliani    = "small"
    client-id-stg  = "small"
    glive-inventory-stg = "medium"
    merchant-stg = "small"
    vis20-emea-stg = "medium"
    pwa3-stg = "large"
    pwa4-stg = "large"
    pricing-service-stg = "medium"
    pwa2-stg = "large"
    pwa-stg = "large"
    pricing-service-cluster-stg = "large"
    vis-stg = "large"
    jdoenhardt-mysql-test = "small"
    vis20-us-stg = "medium"
  }
}

variable "environment_to_dbname_map" {
  type = "map"
  default = {
    gciciliani    = "gcicilianidb"
    client-id-stg  = "client_id_stg"
    glive-inventory-stg = "glive_inventory_stg"
    merchant-stg = "merchant_stg" 
    vis20-emea-stg = "vis20_emea_stg"
    pwa3-stg = "pwa_stg"
    pwa4-stg = "pwa_stg"
    pricing-service-stg = "pricing_service_stg"
    vis20-us-stg = "vis_us_stg"
    pwa2-stg = "pwa2_stg"
    pwa-stg = "pwa_stg"
    pricing-service-cluster-stg = "pricing_service_cluster_stg"
    vis-stg = "vis_stg"
    jdoenhardt-mysql-test = "jdoenhardt_mysql_test"
    vis20-us-stg = "vis20_us_stgA
  }
}


variable "environment_to_remote_replica_map" {
  type = "map"
  default = {
    gciciliani     = 1
    client-id-stg  = 1
    glive-inventory-stg = 1
    merchant-stg = 1
    vis20-emea-stg = 0
    pwa3-stg = 1
    pwa4-stg = 0
    pricing-service-stg = 1
    pwa2-stg = 1
    pwa-stg = 1
    pricing-service-cluster-stg = 1
    vis-stg = 1
    jdoenhardt-mysql-test = 1
    vis20-us-stg = 0
  }
}

variable "environment_to_local_replica_cnt_map" {
  type = "map"
  default = {
    gciciliani     = 1
    client-id-stg  = 1
    glive-inventory-stg = 1
    merchant-stg = 1
    vis20-emea-stg = 1
    pwa3-stg = 1
    pwa3-stg = 1
    pricing-service-stg = 1
    pwa2-stg = 1
    pwa-stg = 1
    pricing-service-cluster-stg = 1
    vis-stg = 1
    jdoenhardt-mysql-test = 1
    vis20-us-stg = 1
  }
}

variable "environment_to_remote_replica_cnt_map" {
  type = "map"
  default = {
    gciciliani     = 1
    client-id-stg  = 1
    glive-inventory-stg = 1
    merchant-stg = 1
    vis20-emea-stg = 0
    pwa3-stg = 1
    pwa4-stg = 0
    pricing-service-stg = 1
    pwa2-stg = 1
    pwa-stg = 1
    pricing-service-cluster-stg = 1
    vis-stg = 1
    jdoenhardt-mysql-test = 1
    vis20-us-stg = 0
  }
}

variable "adminpassword" {}

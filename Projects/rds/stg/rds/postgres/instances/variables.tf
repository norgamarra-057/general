variable "workspace_to_environment_map" {
  type = "map"
  default = {
    mani-stg = "mani-stg"
    jdoenhardt-test = "jdoenhardt-test"
    pgtest-fil = "pgtest-fil"
    gciciliani = "gciciliani"
    ugc-stg= "ugc-stg"
    pctest1 = "pctest1"
    mjtest1 = "mjtest1"
    pgb-test = "pgb-test"
    taxonomyv3-stg = "taxonomyv3-stg"
    tpis-stg = "tpis-stg"
    tpis-emea-stg = "tpis-emea-stg"
    test-stg = "test-stg"
    pgb-test = "pgb-test"
    custom-fields-stg = "custom-fields-stg"
    dev = "dev"
  }
}

variable "environment_to_insttype_map" {
  type = "map"
  default = {
    mani-stg = "db.t2.small"
    jdoenhardt-test = "db.t2.small"
    pgtest-fil = "db.t2.large"
    gciciliani = "db.t2.small"
    ugc-stg= "db.t2.large"
    pctest1 = "db.t2.small"
    mjtest1 = "db.t2.small"
    pgb-test = "db.t2.small"
    taxonomyv3-stg = "db.t3.xlarge"
    tpis-stg = "db.t2.small"
    tpis-emea-stg = "db.m4.xlarge"
    test-stg = "db.t2.large"
    pgb-test = "db.t2.small"
    custom-fields-stg = "db.t2.large"
    dev = "db.t2.small"
  }
}

variable "environment_to_dbname_map" {
  type = "map"
  default = {
    mani-stg = "mani_stg"
    jdoenhardt-test = "jdoenhardt_test"
    pgtest-fil = "pgtest"
    gciciliani = "gcicidb"
    ugc-stg= "ugc_stg"
    pctest1 = "pctest1"
    mjtest1 = "mjtest1"
    pgb-test = "pgb_test"
    taxonomyv3-stg = "taxonomyv3_stg"
    tpis-stg = "tpis_stg"
    tpis-emea-stg = "tpis_emea_stg"
    test-stg = "test_stg"
    pgb-test = "pgb_test"
    custom-fields-stg = "custom_fields_stg"
    dev = "dev"
  }
}

variable "environment_to_primary_region_map" {
  type = "map"
  default = {
    mani-stg = "us-west-1"
    jdoenhardt-test = "us-west-1"
    pgtest-fil = "us-west-1"
    gciciliani = "us-west-1"
    ugc-stg = "us-west-1"
    pctest1 = "us-west-1"
    mjtest1 = "us-west-1"
    pgb-test = "us-west-1"
    taxonomyv3-stg = "us-west-1"
    tpis-stg = "us-west-1"
    tpis-emea-stg = "us-west-2"
    test-stg = "us-west-1"
    pgb-test = "us-west-1"
    custom-fields-stg = "us-west-1"
    dev = "us-west-1"
  }
}

variable "environment_to_remote_region_map" {
  type = "map"
  default = {
    mani-stg = "us-west-2"
    jdoenhardt-test = "us-west-2"
    pgtest-fil = "us-west-2"
    gciciliani = "us-west-2"
    ugc-stg = "us-west-2"
    pctest1 = "us-west-2"
    mjtest1 = "us-west-2"
    pgb-test = "us-west-2"
    taxonomyv3-stg = "us-west-2"
    tpis-stg = "us-west-2"
    tpis-emea-stg = "us-west-1"
    test-stg = "us-west-2"
    pgb-test = "us-west-2"
    custom-fields-stg = "us-west-2"
    dev = "us-west-2"
  }
}

variable "environment_to_size_map" {
  type = "map"
  default = {
    mani-stg = "small"
    jdoenhardt-test = "small"
    pgtest-fil = "large"
    gciciliani = "small"
    ugc-stg = "large"
    pctest1 = "small"
    mjtest1 = "small"
    pgb-test = "small"
    taxonomyv3-stg = "large"
    tpis-stg = "medium"
    tpis-emea-stg = "large"
    test-stg = "large"
    pgb-test = "small"
    custom-fields-stg = "large"
    dev = "small"
  }
}


variable "adminpassword" {}


variable "environment_to_remote_replica_map" {
  type = "map"
  default = {
    gciciliani     = 1
    client-id-stg  = 1
    pgtest-fil     = 1
    vis20-emea-stg = 1
    gciciliani = 1
    ugc-stg = 1
    jdoenhardt-test = 1
    pgb-test = 1
    taxonomyv3-stg = 1
    tpis-stg = 0
    tpis-emea-stg = 0
    test-stg = 1
    pgb-test = 1
    custom-fields-stg = 1
    dev = 0
  }
}

variable "environment_to_local_replica_cnt_map" {
  type = "map"
  default = {
    gciciliani     = 1
    client-id-stg  = 1
    pgtest-fil     = 1
    vis20-emea-stg = 1
    gciciliani = 1
    ugc-stg = 1
    pctest1 = 1
    mjtest1 = 1
    jdoenhardt-test = 1
    pgb-test = 1
    taxonomyv3-stg = 1
    tpis-stg = 2
    tpis-emea-stg = 1
    test-stg = 1
    pgb-test = 1
    custom-fields-stg = 1
    dev = 1
  }
}

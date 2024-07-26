lz_vpc_name = "PrimaryVPC"

aws_region = "us-west-1"
route53_zone_name = "stable.us-west-1.aws.groupondev.com."

                        # SNC1(1)         SNC1(2)            SAC1            DUB1       VPN-DUB1        VPN-SAC1        VPN-SNC1
raas-allow-onprem = ["10.20.0.0/14", "10.24.0.0/15", "10.32.0.0/14", "10.12.0.0/14", "10.37.0.0/16", "10.36.0.0/16", "10.60.0.0/16"]

create-sg-to-allow-conveyor-in-other-region = true
                                              # conveyor-usw2-1   conveyor-usw2-2   conveyor-usw2-3  rapid-usw2-1      rapid-usw2-2      rapid-usw2-3
raas-allow-conveyor-in-other-region-subnets = ["10.221.48.0/20", "10.221.64.0/20", "10.221.80.0/20", "10.223.80.0/20", "10.223.48.0/20", "10.223.64.0/20"]

                        # usw2 - Stable     usw2 - Prod
cloud-jenkins-subnets = ["10.224.48.0/20", "10.224.32.0/20"]

create-sg-to-allow-emr-account = true
raas-emr-account-subnets = ["10.224.224.0/21", "10.216.136.0/21", "10.229.0.0/21", "10.224.224.0/21","10.224.232.0/21","10.224.240.0/21"]

create-sg-to-allow-dnd-account = true
                            # us-west-2b                                                                                                                   # GCP
raas-dnd-account-subnets = ["10.224.200.0/21","10.224.224.0/21","10.224.232.0/21","10.224.240.0/21","10.224.192.0/21","10.224.200.0/21","10.224.208.0/21", "10.181.0.0/21"]

create-sg-to-allow-gcp = true
raas-gcp-subnets = ["10.181.0.0/21", "10.182.0.0/21"]

create-sg-to-allow-conveyor-gcp = true
raas-conveyor-gcp-subnets = ["10.182.8.0/22"]
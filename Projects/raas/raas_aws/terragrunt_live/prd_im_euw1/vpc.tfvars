lz_vpc_name = "PrimaryVPC"

aws_region = "eu-west-1"
route53_zone_name = "prod.eu-west-1.aws.groupondev.com."

                       # SNC1(1)         SNC1(2)         SAC1            DUB1            VPN-DUB1        VPN-SAC1        VPN-SNC1
raas-allow-onprem = ["10.20.0.0/14", "10.24.0.0/15", "10.32.0.0/14", "10.12.0.0/14", "10.37.0.0/16", "10.36.0.0/16", "10.60.0.0/16"]

# Allow conveyor in the other region (RAAS-244)
create-sg-to-allow-conveyor-in-other-region = true
                                              # conveyor-usw1-1   conveyor-usw1-2   conveyor-usw1-3
raas-allow-conveyor-in-other-region-subnets = ["10.211.64.0/19", "10.211.142.0/24", "10.211.96.0/19"]

# RAAS-243
create-sg-to-allow-voucher-account = true
raas-voucher-account-subnets = ["10.1.3.0/24", "10.1.7.0/24", "10.1.11.0/24"]


create-sg-to-allow-emr-account = true
raas-emr-account-subnets = ["10.224.224.0/21"]

create-sg-to-allow-conveyor-gcp = true
raas-conveyor-gcp-subnets = ["10.183.8.0/22"]
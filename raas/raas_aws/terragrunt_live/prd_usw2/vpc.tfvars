lz_vpc_name = "PrimaryVPC"

aws_region = "us-west-2"
route53_zone_name = "prod.us-west-2.aws.groupondev.com."

                       # SNC1(1)         SNC1(2)         SAC1            DUB1            VPN-DUB1        VPN-SAC1        VPN-SNC1
raas-allow-onprem = ["10.20.0.0/14", "10.24.0.0/15", "10.32.0.0/14", "10.12.0.0/14", "10.37.0.0/16", "10.36.0.0/16", "10.60.0.0/16"]

create-sg-to-allow-dnd-account = true
raas-dnd-account-subnets = ["10.222.0.0/20","10.222.16.0/20","10.222.32.0/20"]

create-sg-to-allow-emr-account = true
raas-emr-account-subnets = ["10.214.0.0/21", "10.222.32.0/20"]

# Allow conveyor in the other region (RAAS-244)
create-sg-to-allow-conveyor-in-other-region = true
                                              # conveyor-euw1-1   conveyor-euw1-2   conveyor-euw1-3   conveyor-usw1-a   conveyor-usw1-b   conveyor-usw1-c
raas-allow-conveyor-in-other-region-subnets = ["10.228.48.0/20", "10.228.64.0/20", "10.228.80.0/20", "10.211.64.0/19", "10.211.142.0/24", "10.211.96.0/19"]

create-sg-to-allow-conveyor-gcp = true
raas-conveyor-gcp-subnets = ["10.183.8.0/22"]
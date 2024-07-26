lz_vpc_name = "PrimaryVPCProperSubnets"

aws_region = "us-west-2"
route53_zone_name = "stable.us-west-2.aws.groupondev.com."
subnetid_b = "subnet-0fcf3c3d4b337cc4f" # us-west-2b-AppSubnet
legacy_subnets = true

                          # SNC1(1)         SNC1(2)         SAC1            DUB1            VPN-DUB1        VPN-SAC1        VPN-SNC1
raas-allow-onprem = ["10.20.0.0/14", "10.24.0.0/15", "10.32.0.0/14", "10.12.0.0/14", "10.37.0.0/16", "10.36.0.0/16", "10.60.0.0/16"]

# RAAS-243
create-sg-to-allow-voucher-account = true
raas-voucher-account-subnets = ["10.7.3.0/24", "10.7.7.0/24", "10.7.11.0/24"]

                        # usw2 - Stable     usw2 - Prod
cloud-jenkins-subnets = ["10.224.48.0/20", "10.224.32.0/20"]

create-sg-to-allow-emr-account = true
raas-emr-account-subnets = ["10.224.224.0/21", "10.224.224.0/21","10.224.232.0/21","10.224.240.0/21"]

create-sg-to-allow-dnd-account = true
                            # usw2 Stable                                         usw2 dev
raas-dnd-account-subnets = ["10.224.224.0/21","10.224.232.0/21","10.224.240.0/21","10.224.192.0/21","10.224.200.0/21","10.224.208.0/21"]


# Allow conveyor in the other region (RAAS-244)
create-sg-to-allow-conveyor-in-other-region = true
                                              # conveyor-usw1   
raas-allow-conveyor-in-other-region-subnets = ["10.213.48.0/20", "10.213.64.0/20", "10.213.138.0/24"]

create-sg-to-allow-gcp = true
raas-gcp-subnets = ["10.181.0.0/21", "10.182.0.0/21"]

create-sg-to-allow-conveyor-gcp = true
raas-conveyor-gcp-subnets = ["10.182.8.0/22"]
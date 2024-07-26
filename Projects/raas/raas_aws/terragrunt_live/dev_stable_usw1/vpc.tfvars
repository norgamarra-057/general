lz_vpc_name = "PrimaryVPC"

aws_region = "us-west-1"
route53_zone_name = "stable.us-west-1.aws.groupondev.com."

                          # SNC1(1)         SNC1(2)         SAC1            DUB1            VPN-DUB1        VPN-SAC1        VPN-SNC1
raas-allow-onprem = ["10.20.0.0/14", "10.24.0.0/15", "10.32.0.0/14", "10.12.0.0/14", "10.37.0.0/16", "10.36.0.0/16", "10.60.0.0/16"]
                        # usw2 - Stable     usw2 - Prod
cloud-jenkins-subnets = ["10.224.48.0/20", "10.224.32.0/20"]


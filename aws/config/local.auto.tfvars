### General
aws_region = "us-east-2"
workload   = "litware"

### VPC
vpc_cidr                 = "172.16.0.0/16"
vpc_public_subnet_cidr   = "172.16.10.0/24"
vpc_priv_subnet_cidr     = "172.16.20.0/24"
remote_vpn_workload_cidr = "10.90.0.0/16"

### Firewall
ec2_firewall_ami           = "ami-0041e6f8b54e9c1b7" # pfSense-plus-ec2-24.11-RELEASE-aarch64.img
ec2_firewall_instance_type = "m7g.large"
ec2_firewall_volume_size   = 20

### Server
ec2_server_ami           = "ami-0ac5d9e789dbb455a" # Canonical, Ubuntu, 24.04, arm64 noble image
ec2_server_instance_type = "t4g.micro"
ec2_server_volume_size   = 8

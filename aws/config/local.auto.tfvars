### General
aws_region = "sa-east-1"
workload   = "contoso"

### VPC
vpc_cidr                 = "172.16.0.0/12"
vpc_public_subnet_cidr   = "172.16.50.0/24"
vpc_priv_subnet_cidr     = "172.16.100.0/24"
remote_vpn_workload_cidr = "172.16.0.0/24"

### Firewall
ec2_firewall_ami           = "ami-0dcb8e7f912279c9a"
ec2_firewall_instance_type = "m7g.large"
ec2_firewall_volume_size   = 20

### Server
ec2_server_ami           = "ami-007afe6af8adb148f"
ec2_server_instance_type = "t4g.micro"
ec2_server_volume_size   = 8

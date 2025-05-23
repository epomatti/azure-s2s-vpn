terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                 = "./modules/vpc"
  aws_region             = var.aws_region
  workload               = var.workload
  vpc_cidr               = var.vpc_cidr
  vpc_priv_subnet_cidr   = var.vpc_priv_subnet_cidr
  vpc_public_subnet_cidr = var.vpc_public_subnet_cidr
}

module "firewall" {
  source        = "./modules/ec2/firewall"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  ami           = var.ec2_firewall_ami
  instance_type = var.ec2_firewall_instance_type
  volume_size   = var.ec2_firewall_volume_size
}

module "server" {
  source        = "./modules/ec2/server"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnet_id
  ami           = var.ec2_server_ami
  instance_type = var.ec2_server_instance_type
  volume_size   = var.ec2_server_volume_size

  # Wait for the NAT Gateway
  depends_on = [module.vpc]
}

### Remote Routes ###
resource "aws_route" "r1" {
  route_table_id         = module.vpc.private_route_table_id
  destination_cidr_block = var.remote_vpn_workload_cidr
  network_interface_id   = module.firewall.network_interface_id
}

resource "aws_route" "r2" {
  route_table_id         = module.vpc.public_route_table_id
  destination_cidr_block = var.remote_vpn_workload_cidr
  network_interface_id   = module.firewall.network_interface_id
}

resource "aws_route" "p2s1" {
  route_table_id         = module.vpc.public_route_table_id
  destination_cidr_block = var.remote_vpn_p2s_cidr
  network_interface_id   = module.firewall.network_interface_id
}

resource "aws_route" "p2s2" {
  route_table_id         = module.vpc.private_route_table_id
  destination_cidr_block = var.remote_vpn_p2s_cidr
  network_interface_id   = module.firewall.network_interface_id
}

### Variables ###
locals {
  az1 = "${var.aws_region}a"
  az2 = "${var.aws_region}b"
}

### VPC ###
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.workload}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ig-${var.workload}"
  }
}

### NAT Gateway ###
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "nat-${var.workload}"
  }
}

### PRIVATE ###
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rt-${var.workload}-priv1"
  }
}

resource "aws_route" "private_subnet_to_nat_gateway" {
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_priv_subnet_cidr
  availability_zone = local.az1

  tags = {
    Name = "subnet-${var.workload}-priv1"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

### PUBLIC ###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rt-${var.workload}-public"
  }
}

resource "aws_route" "igw2" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_public_subnet_cidr
  availability_zone = local.az1

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-pub1"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

### REMOVE DEFAULT ###
resource "aws_default_route_table" "internet" {
  default_route_table_id = aws_vpc.main.default_route_table_id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

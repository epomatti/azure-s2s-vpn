data "aws_subnet" "selected" {
  id = var.public_subnet_id
}

locals {
  name = "pfsense-firewall"
}

resource "aws_iam_instance_profile" "default" {
  name = "${local.name}-profile"
  role = aws_iam_role.default.id
}

resource "aws_eip" "admin" {
  domain            = "vpc"
  network_interface = aws_network_interface.admin.id
}

resource "aws_eip" "wan" {
  domain            = "vpc"
  network_interface = aws_network_interface.wan.id

  depends_on = [aws_network_interface_attachment.wan]
}

resource "aws_instance" "default" {
  ami           = var.ami
  instance_type = var.instance_type

  availability_zone    = data.aws_subnet.selected.availability_zone
  iam_instance_profile = aws_iam_instance_profile.default.id

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring    = false
  ebs_optimized = true

  root_block_device {
    encrypted   = true
    volume_size = var.volume_size

    tags = {
      Name = "vol-${local.name}"
    }
  }

  primary_network_interface {
    network_interface_id = aws_network_interface.admin.id
  }

  lifecycle {
    ignore_changes = [
      ami,
      associate_public_ip_address,
      user_data
    ]
  }

  tags = {
    Name = local.name
  }
}

resource "aws_network_interface" "admin" {
  subnet_id         = var.public_subnet_id
  security_groups   = [aws_security_group.default.id]
  source_dest_check = false

  tags = {
    Name = "nic-${local.name}-admin"
  }
}

resource "aws_network_interface" "wan" {
  subnet_id         = var.public_subnet_id
  security_groups   = [aws_security_group.default.id]
  source_dest_check = false

  tags = {
    Name = "nic-${local.name}-wan"
  }
}

resource "aws_network_interface" "private" {
  subnet_id         = var.private_subnet_id
  security_groups   = [aws_security_group.default.id]
  source_dest_check = false

  tags = {
    Name = "nic-${local.name}-private"
  }
}

resource "aws_network_interface_attachment" "wan" {
  instance_id          = aws_instance.default.id
  network_interface_id = aws_network_interface.wan.id
  device_index         = 1
}

resource "aws_network_interface_attachment" "private" {
  instance_id          = aws_instance.default.id
  network_interface_id = aws_network_interface.private.id
  device_index         = 2
}

### IAM Role ###
resource "aws_iam_role" "default" {
  name = local.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm-managed-instance-core" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_security_group" "default" {
  name        = "ec2-ssm-${local.name}"
  description = "Controls access for EC2 via Session Manager"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-ssm-${local.name}"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

### Generic HTTP  Rules ###

resource "aws_security_group_rule" "allow_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_egress_internet_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_egress_internet_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  description       = "Allow All Egress"
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

### Firewall Rules - Ingress ###
resource "aws_security_group_rule" "allow_ingress_udp_500" {
  description       = "UDP500"
  type              = "ingress"
  from_port         = 500
  to_port           = 500
  protocol          = "UDP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_ingress_udp_4500" {
  description       = "UDP4500"
  type              = "ingress"
  from_port         = 4500
  to_port           = 4500
  protocol          = "UDP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_ingress_openvpn" {
  description       = "OpenVPN"
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "UDP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_all_ingress" {
  description       = "Allow All Ingress"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_ingress_icmp" {
  description       = "ICMP"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "ICMP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

### Firewall Rules - Egress ###
resource "aws_security_group_rule" "allow_egress_icmp" {
  description       = "ICMP"
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "ICMP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

### Application ###
resource "aws_security_group_rule" "allow_application_ingress_vpc_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_application_ingress_vpc_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.default.id
}

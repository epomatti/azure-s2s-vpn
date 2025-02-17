variable "aws_region" {
  type = string
}

variable "workload" {
  type = string
}

### firewall ###
variable "ec2_firewall_ami" {
  type = string
}

variable "ec2_firewall_instance_type" {
  type = string
}

variable "ec2_firewall_volume_size" {
  type = number
}


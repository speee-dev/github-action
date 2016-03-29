# ================================================================================
# VPC
# ================================================================================
resource "aws_vpc" "github_action" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
    "Name" = "github_action"
  }
}

# ================================================================================
# Internet Gateway
# ================================================================================
resource "aws_internet_gateway" "github_action" {
  vpc_id = "${aws_vpc.github_action.id}"

  tags {
    "Name" = "github_action"
  }
}

# ================================================================================
# Route Table
# ================================================================================
resource "aws_route_table" "github_action_public" {
  vpc_id = "${aws_vpc.github_action.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.github_action.id}"
  }

  tags {
    "Name" = "github_action_public"
  }
}
resource "aws_main_route_table_association" "github_action" {
  vpc_id         = "${aws_vpc.github_action.id}"
  route_table_id = "${aws_route_table.github_action_public.id}"
}

# ================================================================================
# Subnet
# ================================================================================
# AZ:
#   ap-northeast-1a: 00
#   ap-northeast-1c: 01
# class B:
#   | class | function id           | AZ    | subnet range          |
#   | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
#   | 128 + fid                     | az << 6                       |
# class C:
#   | class | function id                   | AZ    | subnet range  |
#   | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
#   | 192 + (fid >> 2)              | (fid & 0b11) << 6 + (az << 4) |
# ================================================================================

# Class: C
# ID:    0
# Name:  App
resource "aws_subnet" "github_action_app_1a" {
  vpc_id                  = "${aws_vpc.github_action.id}"
  cidr_block              = "10.1.192.0/28"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags {
    "Name" = "github_action_app_1a"
  }
}
resource "aws_route_table_association" "github_action_app_1a" {
  subnet_id      = "${aws_subnet.github_action_app_1a.id}"
  route_table_id = "${aws_route_table.github_action_public.id}"
}

# ================================================================================
# Network ACL
# ================================================================================
# 特殊設定する場合のみ記述

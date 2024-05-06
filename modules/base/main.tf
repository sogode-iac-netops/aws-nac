resource "aws_vpc" "base" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet_config

  vpc_id = aws_vpc.base.id
  cidr_block = each.value.cidr
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = false
#  assign_ipv6_address_on_creation = true

  tags = {
    Name = each.value.description
    ipam_id = each.value.ipam_id
    scope = each.value.scope
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.base.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "rt_local_internet" {
  vpc_id = aws_vpc.base.id
  tags = {
    Name = "Local Internet Route Table"
  }
}

resource "aws_route" "rt_local_internet-ipv4-internet" {
  route_table_id = aws_route_table.rt_local_internet.id
  gateway_id = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "rt_local_internet-ipv6-internet" {
  route_table_id = aws_route_table.rt_local_internet.id
  gateway_id = aws_internet_gateway.internet_gateway.id
  destination_ipv6_cidr_block = "::/0"
}

resource "aws_route_table_association" "rt_assoc_public_1" {
  for_each = {
      for idx, subnet in aws_subnet.subnets :
        subnet.id => subnet
        if subnet.tags.scope == "public"
  }
  route_table_id = aws_route_table.rt_local_internet.id
  subnet_id = each.value.id
}
resource "aws_vpc" "spoke" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Application = var.app_name
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.spoke.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name    = each.value.description
    ipam_id = each.value.ipam_id
    scope   = each.value.scope
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tga_spoke" {
  subnet_ids = [
    for _, subnet in aws_subnet.subnets : subnet.id
    if subnet.tags.scope == "transitgateway"
  ]
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.spoke.id
  tags = {
    Name = "Spoke VPC"
    Application = var.app_name
  }
}

resource "aws_ec2_transit_gateway_route" "r_spoke" {
  destination_cidr_block         = aws_vpc.spoke.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tga_spoke.id
  transit_gateway_route_table_id = var.tgw_rt_id
}

resource "aws_route" "r_default" {
  route_table_id         = aws_vpc.spoke.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw_id
}

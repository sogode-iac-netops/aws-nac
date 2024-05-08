#
# Module: transit_gateway
# Description:
#   Create a transit gateway in a region with two routes pointing to the
#   local Base VPC:
#   1: Default route
#   2: Local Base VPC specific route
#
# Depends on:
# - Local base VPC
#
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Central transit gateway"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "TGW ${var.aws_region}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tga_base_vpc" {
  subnet_ids = var.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpc_id
  tags = {
    Name = "Base VPC"
  }
}

resource "aws_route" "r_base_10" {
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  route_table_id = var.base_rt_id
}

resource "aws_ec2_transit_gateway_route" "r_base" {
  destination_cidr_block = var.base_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tga_base_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

resource "aws_ec2_transit_gateway_route" "r_ipv4_default" {
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tga_base_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}
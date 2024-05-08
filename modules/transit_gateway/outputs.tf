#
# Module transit_gateway outputs
output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "tgw_association_default_route_table_id" {
  value = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

output "tgw_propagation_default_route_table_id" {
  value = aws_ec2_transit_gateway.tgw.propagation_default_route_table_id
}

output "tga_base_vpc_attachment_id" {
  description = "Transit Gateway Attachment to local base VPC"
  value = aws_ec2_transit_gateway_vpc_attachment.tga_base_vpc.id
}

output "r_base_10_id" {
  description = "ID of 10.0.0.0/8 route in base VPC"
  value = aws_route.r_base_10.id
}

output "r_base_id" {
  value = aws_ec2_transit_gateway_route.r_base.id
}

output "r_ipv4_default_id" {
  value = aws_ec2_transit_gateway_route.r_ipv4_default.id
}


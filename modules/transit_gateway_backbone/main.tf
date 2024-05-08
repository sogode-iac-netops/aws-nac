#
# Module: transit_gateway_backbone
# Description:
#   Creates a transit gateway backbone connection to other transit gateways
#   Includes:
#   - Peering connection
#   - Route
#
# Depends on:
# - Local base VPC
#

resource "aws_ec2_transit_gateway_route" "routes" {
  for_each = var.destinations

  destination_cidr_block         = each.value.dst_cidr_block
  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = each.value.route_table_id
}
